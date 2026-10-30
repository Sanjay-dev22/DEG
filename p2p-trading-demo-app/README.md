# P2P Trading Demo App

Four real, independent web apps trading real solar energy over the real
local Beckn/onix network (`network/devkits/p2p-trading-ies-wave2/` in this
folder, a trimmed copy of the public `beckn/DEG` devkit plus the aggregator
and grid adapters added here), replacing the
`fidedocker/sandbox-2.0` fixture-replay stubs the devkit ships with:

| App | Port | Role |
|---|---|---|
| **Seller Platform** (`seller-app/`) | 4002 | an individual prosumer — publishes small offers, then waits |
| **Buyer Platform** (`buyer-app/`) | 4001 | an independent bulk buyer — discovers and buys whatever fits, including a pooled block |
| **Aggregator Platform** (`aggregator-app/`) | 4003 | pools several small sellers' offers into one bigger block, matches demand, owns that block's whole lifecycle |
| **Grid/DISCOM Platform** (`grid-app/`) | 4004 | the demand side — posts a bulk requirement and buys the matching block itself |

For the full engineering history, every bug found and fixed, and the exact
reasoning behind each design decision, see **`KNOWLEDGE-BASE.md`** — it is
the living source of truth for this project and is kept up to date after
every change. `ARCHITECTURE.md` is the original pre-build design doc; it
predates all four apps actually being built and is kept only as history,
not as a description of current behavior.

## What's real here

Every message (`catalog/publish`, `discover`, `select`, `init`, `on_init`,
`confirm`, `on_confirm`, `status`, `on_status`) is a genuine, signed Beckn
v2 call through real onix adapters — real schema validation, real `.rego`
policy enforcement (including a real live rejection path), real settlement
math, and (for buyer-app and grid-app trades) a real cascade to the
external IES ledger. Nothing is scripted or replayed; every number in the
UI came from a real HTTP round trip started by an actual click.

Four independent onix adapter instances now run underneath these four
apps — `onix-sellerapp`, `onix-buyerapp`, `onix-aggregatorapp`,
`onix-gridapp` — each with its own routing hostname
(`{seller,buyer,aggregator,grid}app.example.com`). `onix-aggregatorapp` and
`onix-gridapp` reuse `sellerapp.example.com`'s and `buyerapp.example.com`'s
already-registered signing keys respectively rather than a newly-registered
identity (no new DeDi registration needed — see `KNOWLEDGE-BASE.md` §9 for
exactly why that's safe and how it works).

**Storage**: SQLite (one file per app, `node:sqlite`, no external DB
server). **Live updates**: a plain WebSocket per app where used (seller-app,
buyer-app, aggregator-app) — no Redis, no job queue. **Auth**: none — you
operate every platform yourself, exactly like the underlying devkit's own
demo does.

## Quick start (fresh machine)

Everything the demo needs is in this folder — no other devkit or clone is
required.

**Prerequisites**

| Need | Notes |
|---|---|
| Git | to clone this repo |
| Docker with Compose v2 | Docker Desktop (Mac/Windows) or Docker Engine (Linux). Windows: use WSL2. Needs ~2 GB free disk for images |
| Node.js **22.13 or newer** | the apps use the built-in `node:sqlite` module; check with `node -v` |
| Python 3 | only to serve the policy file on port 8099 |
| Internet access | the onix adapters fetch the Beckn schema and the shared catalog/registry; no accounts or logins needed |
| `cloudflared` (optional) | only for real **Discover offers** and for sharing dashboards, see below |

**Free ports:** 4001–4004 (apps), 8081, 8082, 8083, 8084, 8085, 8086, 9000,
18084, 18085 (onix and router), 8099 (policy file).

```bash
git clone https://github.com/Sanjay-dev22/DEG.git
cd DEG/p2p-trading-demo-app
./run-demo.sh up
```

`up` pulls the images (it falls back to `mirror.gcr.io` if Docker Hub
rate-limits anonymous pulls), starts the policy server, brings up the whole
onix network, runs `npm install` in each app, and starts the four apps.
The first run takes a few minutes. When it prints **ready**, open:

| Dashboard | URL |
|---|---|
| Seller | http://localhost:4002 |
| Buyer | http://localhost:4001 |
| Aggregator | http://localhost:4003 |
| Grid/DISCOM | http://localhost:4004 |

Then either click through flow B below by hand, or run it in one command:

```bash
./run-demo.sh flow          # needs real Discover, see "Real Discover needs a public address"
./run-demo.sh flow --seed   # bypasses Discover, works with no tunnel
```

Other commands: `./run-demo.sh reset` (wipe all four apps),
`./run-demo.sh tunnel` (public dashboard URLs), `./run-demo.sh down`
(stop everything). Logs for the host processes are in `.run/`; adapter logs
are `docker logs onix-aggregatorapp` (and `onix-gridapp`, `onix-sellerapp`,
`onix-buyerapp`).

### Windows (Git Bash or WSL2)

Run everything from **Git Bash** (or a WSL2 shell) with **Docker Desktop
running**. Do not double-click the script; type the command in an open
terminal so any error stays visible:

```bash
bash ./run-demo.sh up
```

- **Window closes instantly / `pipefail: invalid option name`:** the script
  was checked out with Windows (CRLF) line endings. `bash ./run-demo.sh up`
  repairs the file itself and carries on. If you run it as `./run-demo.sh`
  and still get `bad interpreter` or `\r: command not found`, run this once:
  ```bash
  sed -i 's/\r$//' run-demo.sh
  ```
  A fresh clone is correct automatically (`.gitattributes` forces LF). To
  fix an old clone: `git pull`, then `git add --renormalize . && git checkout -- .`
- **See exactly what failed:** `bash -x ./run-demo.sh up 2>&1 | tail -40`.
- Python may be installed as `python` or `py`; the script finds it.
- If a step needs Docker, make sure the Docker Desktop whale icon says
  "running" before you start.

### Real Discover needs a public address

**Discover offers** is asynchronous: the shared discovery service sends its
reply to a public address for `onix-buyerapp`. Without one, Discover returns
nothing. Install `cloudflared`
(https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/)
and start with:

```bash
./run-demo.sh down
./run-demo.sh up --tunnel
```

That tunnels port 8081 and writes the address to `buyer-app/public-bap-uri.txt`
before buyer-app starts (it is read once at startup). A laptop on a normal
home or office network works. Locked-down networks that block outbound
tunnels do not; use `flow --seed` there, which copies seller-app's own live
offers into buyer-app's discovered list and says so in the offer name.

### What the setup runs

For reference, `run-demo.sh up` is equivalent to:

```bash
# onix network: seller, buyer, aggregator, grid adapters + ledgers + router
cd network/devkits/p2p-trading-ies-wave2/install && docker compose up -d
# policy file server (the locally amended contract policy)
cd network/specification/policies && python3 -m http.server 8099
# each app
cd seller-app && npm install && npm start      # likewise buyer-app, aggregator-app, grid-app
```

If an onix adapter is not on the default port, set `ONIX_SELLER_URL`,
`ONIX_BUYER_URL`, `ONIX_AGGREGATOR_URL` or `ONIX_GRID_URL` before starting
the matching app (defaults: 8082, 8081, 18084, 18085).

### Troubleshooting

- **`429 Too Many Requests` pulling images:** Docker Hub's anonymous limit.
  `run-demo.sh` retries through `mirror.gcr.io` automatically; or `docker login`.
- **`node:sqlite` not found:** upgrade Node to 22.13 or newer.
- **Publish fails with a policy error:** the policy server is not running.
  `curl http://localhost:8099/p2p-trading-ies-wave2-contractpolicy-local-amended.rego`
  should return the file; the adapters cache a fetched policy for a long time,
  so after changing it run `docker compose restart` in the `install` folder.
- **Port already in use:** stop whatever holds it, or `./run-demo.sh down` first.
- **Containers cannot reach the host (Linux):** the compose file maps
  `host.docker.internal` to the host gateway already; needs Docker 20.10+.
- **Behind a TLS-inspecting proxy** (adapters crash with `x509: certificate
  signed by unknown authority`): export the proxy's CA and run
  `CA_BUNDLE=/path/to/ca.pem ./run-demo.sh up`. It mounts the file into every
  onix container via `docker-compose.proxy-ca.yml`.

## The demo flow

There are two independent paths through this network. Run either, or
both together.

### A. Direct P2P — seller ↔ buyer, no aggregation

1. **Seller** (`:4002`): enter a quantity/price, click **Publish offer**.
   This really calls `catalog/publish` on `onix-sellerapp`.
2. **Buyer** (`:4001`): click **Discover offers** (a real `discover` —
   allow 5–20 seconds for real network propagation across the shared
   catalog, not instant), or paste the offer id directly into "Buy
   directly." The bid price is prefilled with the seller's ask but
   editable — leave it to buy outright, lower it to negotiate. Click
   **Send bid** — a real, signed `init`.
3. **Seller**: the bid appears in "Incoming requests" against the seller's
   own current ask. Three real outcomes: **Accept bid** (real `on_init`
   echoing the buyer's terms), **Send counter-offer** (real `on_init` with
   the seller's own price/quantity instead), or **Decline** (no onix call
   at all — a BPP never answering `init` is valid Beckn behavior; the
   buyer is told via a small app-to-app notification endpoint).
4. If countered, the buyer sees **Accept counter** (real `confirm`) or
   **Decline counter**. If the seller's `on_init` matched the original bid
   exactly, `confirm` fires automatically — no extra step.
5. Seller auto-sends `on_confirm` on receiving `confirm`. Both dashboards
   flip to **Active**, live.
6. **Seller**: the active trade shows **Report delivery & settle**,
   prefilled with a suggested, editable meter reading. Submitting sends a
   real `on_status`. Both dashboards flip to **Settled** with the real
   computed ₹ amount.
7. **The rejected path**: on the buyer's form, set "Trade as" to
   **Blocked discom** before bidding — the real `contractpolicyenforcer`
   step on `onix-sellerapp` NACKs it live with a real, specific,
   human-readable policy violation message.
8. **Full protocol trace**: any trade row's **Show trace** toggle expands
   every real Beckn hop logged for that transaction, with direction,
   timestamp, and the actual raw payload.

### B. Demand-first aggregation — grid ↔ aggregator ↔ pooled sellers

This is the realistic shape real demand-response/flexibility markets use
(FERC Order 2222, UK's Piclo Flex): the large buyer states what it needs
*before* anything is pooled, rather than pooling first and hoping a buyer
shows up. See `KNOWLEDGE-BASE.md` §9 for the full design and every bug
found building it.

1. **Seller** (`:4002`): publish a few small offers (as above).
2. **Grid/DISCOM** (`:4004`): post a requirement — quantity + a max
   price/kWh.
3. **Aggregator** (`:4003`): click **Discover offers** (same real
   propagation delay as above), then **Recommend pool** on the posted
   requirement — a real cheapest-first match against currently-discovered
   offers, capped at the requirement's own price ceiling. It's honest
   about a shortfall rather than hiding one. **Apply recommendation to
   pool**, then **Publish pooled block** — mints a brand-new catalog entry
   under the aggregator's own onix identity (`onix-aggregatorapp`), not
   seller-app's.
4. **Grid/DISCOM**: once the requirement shows `PUBLISHED`, click **Buy
   available energy** — a real, signed `init`→`confirm` sent through
   `onix-gridapp`, grid-app's own onix identity (reusing buyer-app's
   registered keys, routed separately — see §9's Phase 2). This is a
   genuinely different real buyer from buyer-app; buyer-app has no special
   role in this flow and could independently buy the same public block
   too (whoever confirms first gets it).
5. **Aggregator**: once the trade is `Active`, enter a delivered-kWh
   reading and **Report delivery** — a real `on_status`, settled, with the
   proceeds split back to each pooled seller at their own original price
   and the aggregator's real margin shown explicitly (click any seller row
   to expand the full calculation).
6. **A requirement doesn't have to be filled by one block.** If what's
   currently pooled is less than the requirement asks for, publishing
   anyway is allowed — grid-app buys what's available, honestly reports
   the remaining shortfall, and the requirement stays open. When a new
   seller's offer shows up later (even just one), **Recommend pool** is
   still available on that same requirement to top it up; it flips to
   `FULFILLED` once the cumulative bought quantity meets the original ask.

## Sharing dashboards externally

`./run-demo.sh tunnel` does the steps below for all four dashboards.


Each app is a plain `localhost` HTTP server — to let someone else reach
one, tunnel it (e.g. `cloudflared tunnel --url http://localhost:4002`) and
share the printed URL. Buyer-app's real `discover` additionally needs a
public address for the shared discovery service's async reply to land on;
if tunneling `onix-buyerapp`'s own port (not the dashboard's), write that
tunnel's URL into `buyer-app/public-bap-uri.txt` *before* starting
buyer-app (it's read once at startup).

## Resetting between demo runs

Every app exposes its own `POST /api/reset`, wiping just that app's own
SQLite tables:
```bash
curl -X POST http://localhost:4002/api/reset   # seller-app
curl -X POST http://localhost:4001/api/reset   # buyer-app
curl -X POST http://localhost:4003/api/reset   # aggregator-app
curl -X POST http://localhost:4004/api/reset   # grid-app
```
Dashboards update live (or on next poll) to show an empty state — no
restart needed. Resetting one app never resets another; reset all four
for a genuinely clean demo run.

## Honesty notes (read before demoing)

- **Discover takes real time.** The shared catalog is a real, multi-tenant
  network — a fresh `publish` can take anywhere from a few seconds up to
  ~20 seconds to actually propagate to a `discover` caller. This is real
  network behavior, not a bug to route around; if a discover comes back
  empty, wait and click it again rather than assuming something's broken.
- **Known, disclosed simplifications** — not hidden, not silently wrong:
  aggregator-app's own `GET /api/about` lists every one live (reused
  signing identities instead of new DeDi registration, cheapest-first
  greedy matching rather than a true optimizer, proportional disaggregation
  rather than per-member smart meters, and more) — also written out in
  full in `KNOWLEDGE-BASE.md` §9.
- **Settlement math is computed independently in more than one place by
  design.** The real `contractpolicyenforcer` plugin evaluates the linked
  `.rego` policy against whatever `on_status` payload it receives; each
  app also computes the identical formula itself so its own UI has an
  amount to show immediately, since there's no callback *back* to the
  sender after it sends `on_status`.
- **Several real bugs were caught by actually using this system**, not
  invented for effect — every one of them, what broke, and exactly how
  it was fixed is written up in `KNOWLEDGE-BASE.md` (§5, §9, and the
  Aggregation v2 / Phase 2 sections in particular).
