# Project Summary

A quick-read status of every workstream in this project. For the full
day-by-day detail behind any of this — including exact quotes for the
key decisions and corrections — see `logbook.md`.

---

## 1. UC3 — Policy as Code / Tariff Intelligence (India Energy Stack)

A working prototype proving different billing systems can compute
**identical bills** from one signed, machine-readable tariff object
instead of a PDF — verified end-to-end against the real `beckn/DEG`
sandbox network, including onix's own validator independently confirming
schema-conformance and the trade genuinely landing on a live third-party
network participant (IntelliGrid AMI Services).

**Status (updated 2026-10-15): reopened, rebuilt from scratch to real
submission grade, still not publicly submitted.**
- **Three repos now exist, in order, each superseding the last**:
  `github.com/Sanjay-dev22/myprotoiec` (in `GITHUB REPO/ies-prototype/`)
  — the original, public, first working prototype, superseded;
  `github.com/Sanjay-dev22/ies-sumbit` (in `GITHUB REPO/ies-submission/`)
  — private, an intermediate rewrite, 3 further weeks of real work
  committed locally only (`45ff97c`, 12 Oct) and never pushed; and
  **`github.com/Sanjay-dev22/ies-uc3-policy-as-code`** (local path
  `C:\Users\Sanjay\Desktop\DEG\ies-uc3-policy-as-code`) — the current,
  active, submission-grade repo, built fresh on 27 Sep and the only one
  still being maintained.
- **Real decision on record, both directions**: first explicitly closed
  ("there is no profit for organization... open source contribution"),
  then reopened the same session; paused again after the first team
  presentation found no clear commercial angle; **reopened a second time
  on 2026-09-27** for a genuine submission-grade rebuild, which is still
  the live state.
- Real defects found and fixed in the 27 Sep – 9 Oct hardening pass: a
  slab-boundary off-by-one (headline bill corrected to **Rs 2,434.40**);
  the cryptographic signature widened from covering `policy` alone to the
  whole `{policy, publication}` envelope; two live schema-version typos
  (`DatasetItem`/`Payment` missing a `v`), found only by actually running
  the reference implementation against the real sandbox end to end; a
  full "too AI-generated" tone pass after a real, in-person review on
  5 Oct where reviewers said the proposal and wider repo read as
  machine-generated and "not acceptable" — not just written feedback —
  plus removal of every trace of the repo's own iterative build history,
  so it reads as one coherent finished piece.
- **Standing rule for this one repo specifically**: no git operation of
  any kind is run by Claude on it — the user does every commit/push
  personally so no Claude co-author trailer ever appears in its history;
  every update is kept as a single, fresh, current-dated commit (current:
  `1968c4b`). Confirmed this is purely a presentational choice, not
  something IES itself treats as disqualifying — the real government
  program's own repository visibly uses the same Claude-assisted-commit
  convention.
- **Open step, unchanged:** the "Contribute to IES" Google Form
  (`forms.gle/ESVk4PDcfEerPo6f7`) has still never been submitted.

## 2. P2P Energy Trading — sandbox demo, Grid Pulse, the demo app, an aggregator, and a full gap re-verification (updated 2026-10-15)

A real, local Docker network (Beckn 2.0 LTS, `p2p-trading-ies-wave2`
devkit) running an actual signed `publish → discover → init → confirm →
settle` solar trade across two different electricity companies, with
real policy-computed settlement (₹437.15) and a real policy rejection
case — plus **Grid Pulse**, a standalone interactive visualizer that lets
anyone click through all 31 real hops with real payloads (now with a
plain-English "what's happening" line, full endpoint+method, and a
"worth knowing" real-code callout on every single hop), two companion
guides (a zero-jargon layman guide, a hands-on Postman deep-dive), and a
**second, newer interactive demo app** — two real Node/Express apps
(`seller-app`, `buyer-app`) a live audience clicks through directly,
trading over the same real network in real time instead of watching a
scripted replay.

**Status: Grid Pulse + guides done, live, fully documented. The demo app
now has four real dashboards (seller, buyer, aggregator, grid/DISCOM), a
demand-first aggregation layer with its own onix identity, 24 documented
software/protocol gaps (4 fixed and proven live), a full standing
architecture reference, and a sourced write-up of what's still missing
for a real rollout.**
- Demo runbook + logs (original scripted demo): `p2p-trading/RUNBOOK.md`,
  `p2p-trading/demo-logs/`.
- Live, hosted, and reusable by others:
  - `https://nharuvi.com/beckn` — Grid Pulse itself
  - `https://nharuvi.com/beckn/notes` — presenter speaker notes
  - `https://nharuvi.com/beckn/layman` — plain-English companion guide
  - `https://nharuvi.com/beckn/postman` — hands-on Postman deep-dive
  - `github.com/Sanjay-dev22/grid-pulse`,
    `github.com/Sanjay-dev22/p2p-trading-live-demo` (source repos)
- **New**: `github.com/Sanjay-dev22/p2p-trading-demo-app` — the
  interactive demo app, self-contained (no Python/Redocly/sparse-clone
  needed), README written for a genuinely fresh machine. Verified
  end-to-end via real fresh clones multiple times, most recently
  settling a real ₹124.45 trade after fixing three real bugs a
  corporate-laptop test caught (a native-dependency install failure
  fixed by switching to Node's built-in `node:sqlite`; a `Date.now()`
  race producing mismatched catalog ids; a silent error-swallowing bug
  that showed bare "null" instead of the real rejection reason) plus one
  real UX gap (the seller dashboard never showed its own offers' IDs,
  now fixed with a "My published offers" panel).
- Design docs for the demo app: `p2p-trading-app/ARCHITECTURE.md` (a
  full production-grade design, deliberately shelved for later) and
  `p2p-trading-app/DEMO-APP-PLAN.md` (the lightweight design actually
  built).
- On the corporate laptop, two distinct real network issues were found:
  `discover` hit a corporate SSL-inspecting proxy on a real external
  domain (`x509: certificate signed by unknown authority`) — a genuine
  network-policy limit, no code fix possible. `init`/Buy's failure took
  two rounds to fully diagnose: Docker Desktop itself was found to
  auto-inject `HTTP_PROXY`/`HTTPS_PROXY` into every container (via a
  local `px` NTLM-auth relay the corporate laptop's Docker setup depends
  on) — the first `NO_PROXY` fix (all six `onix-*` services) had no
  effect because `beckn-router` (Caddy) itself, which makes its own
  separate second hop per message, was missed. Both fixed (confirmed via
  real onix/router source code, not just logs) and re-verified harmless
  on an unaffected machine, but **whether this specific fix works on the
  actual corporate laptop was never confirmed** — superseded by the
  decision below before a retest happened.
- **Pivoted the whole demo's hosting strategy**: since the corporate
  laptop can't reliably run this Docker stack at all, the entire local
  setup (both dashboards + `onix-buyerapp`) is now exposed via
  **Cloudflare Quick Tunnels** (`cloudflared tunnel --url http://localhost:<port>`,
  zero-signup, already installed) to real public HTTPS URLs — the
  corporate laptop just opens a browser tab, no Docker/Node/networking
  of its own required. Log files: `cf-seller.log`, `cf-buyer.log`,
  `cf-onix-buyerapp.log` at the DEG root.
  - This introduced a mixed-content bug (a page served over `https://`
    silently refuses a plain `ws://` connection) — both dashboards' live
    WebSocket updates got stuck on "connecting…"; fixed by deriving
    `wss://` vs `ws://` from `location.protocol` instead of hardcoding it.
  - Tunneling `onix-buyerapp` itself turned out to be the missing piece
    for `discover`, too (see next point) — the real discovery service has
    no way to reach a `bapUri` that only resolves inside the local Docker
    network, so it needs a genuinely public callback address.
- **`discover` now genuinely works end-to-end** (previously silently
  returned nothing, no matter how long you waited — the one issue
  explicitly flagged as most important for the demo). Three real,
  independent bugs, found by reading actual `docker logs` rather than
  guessing: (1) the buyer's `bapUri` needed to be the public tunnel URL,
  not the local-only address, via a new `PUBLIC_BAP_URI` env var; (2) the
  real callback action name is `on_discover`, not `catalog` (an earlier
  untested guess) — added to the buyer's routing config and webhook
  handler; (3) `extendedSchema_enabled` was rejecting the *entire* shared,
  multi-tenant catalog response atomically whenever any one historical
  entry from any other real tester was non-conformant — disabled on the
  buyer's schema-validator module specifically. Verified live: discover
  now returns dozens of real offers, including ones from a genuinely
  different real participant on the shared network
  (`bpp.ies.gigawatt.network`) — solid, demonstrable proof this is a real
  shared test network, not just our own two apps talking to themselves.
- **Buy-flow hardened against real edge cases** (price must be the
  seller's, not editable; quantity must be capped to what's really
  available; a foreign/unknown offer must never be buyable). Testing the
  newly-working discover turned up a real bug along the way: buying a
  card from a genuinely different real seller silently created a trade
  that could never resolve (our own `init` always routes to our own
  seller, regardless of whose offer it actually is — reproduced,
  confirmed, then fixed). Now: every Buy path (card click or manual
  paste) resolves the offer against the Seller Platform's own live REST
  API first — price is always the seller's real published figure (never
  trusted from client input, closing off a tampered-price form or a raw
  API call), quantity is capped to what's really available, and a
  foreign or unknown offer is refused server-side with a clear reason
  before any `init` is ever sent. The "Buy directly" paste-an-ID form now
  live-resolves what you typed and locks price/caps quantity accordingly;
  discovered cards from a different real seller show "view only" instead
  of a Buy button that would otherwise mislead.
- Also added: a real **Reset demo** button on both dashboards, after
  clarifying that restarting `npm start` never clears data by design
  (it's a real SQLite file, not in-memory state); and a fix to stop the
  offers/trades lists from fully re-rendering (and flickering) every 5s
  poll when nothing had actually changed.
- **Network Dashboard built** (`buyer-app/public/network.html`): live
  view of every offer discoverable on the shared network (own
  highlighted), plus this platform's own trades independently verified
  against the real external DEG ledger (a real Ed25519-signed query, new
  `buyer-app/ledger.js`) — each shown with its own real cryptographic
  hash as proof. Building it surfaced a real gap worth fixing first:
  **new trades made through this demo app were never actually reaching
  that real external ledger at all** (only two local discom-ledger
  sandboxes) — root-caused to the seller cloning the buyer-originated
  contract's local ledger fields verbatim, unlike the *old* scripted
  demo, which had a real override for exactly this. Fixed
  (`seller-app/beckn.js`'s `pointSellerDiscomAtRealLedger`, matching the
  old demo's real values found in the devkit's own reference fixtures)
  and verified live: a fresh publish→buy→accept→deliver cycle's
  transaction is now confirmed present on the real ledger with its own
  real hash. Also corrected an earlier wrong claim that the real ledger
  query was scoped to only the caller's own party — it's genuinely
  global; the earlier test just hadn't queried a window with other
  testers' data in it.
- **Two more real bugs found and fixed during a fresh rehearsal**: (1)
  offers were mislabeled "ours" almost across the board, because
  `sellerapp.example.com`/`buyerapp.example.com` are the devkit's own
  generic tutorial example IDs, not unique per-user identities — many
  different real strangers on the shared network reuse them verbatim.
  Fixed by determining "ours" from real live membership in the Seller
  Platform's own current catalog instead of a `seller_id` string match,
  and added a "discovered X ago" timestamp to every offer so stale
  historical entries are easy to distinguish from fresh ones. (2) The
  ledger panel hit a real, intermittent 401 from the external ledger
  service's own side; fixed with an automatic one-retry-with-fresh-
  signature before falling back to cache.
- Also discovered a real, unavoidable constraint: the dev machine's free
  memory is tight enough that the demo's background processes (both Node
  apps, all 3 tunnels) get OOM-killed every 20–40 minutes under normal
  running conditions. Not fixable in code — mitigated by closing other
  apps and re-verifying links before relying on them, every time.
- **New (2026-09-15): real negotiation, not just publish/accept.** The
  buyer's price is now a genuine editable bid (defaults to the seller's
  ask, so the simple path is unchanged); the seller can Accept, send a
  real Counter-offer (same `on_init` shape, different price/qty — no new
  Beckn action), or Decline. A genuine counter pauses the buyer for an
  explicit accept/decline instead of auto-confirming; declines (either
  side) send no protocol message and instead notify the other platform
  over a direct app-to-app endpoint (same category as the existing
  `resolveOffer()`/`my-offers` calls). Also added: a per-trade expandable
  **protocol trace** (every real Beckn hop + decision, with raw payloads,
  logged to a new `events` table) so it's visible exactly which hop is
  happening without a confusing button per protocol verb; "Mark as
  delivered" rebuilt into an explained, editable "Report delivery &
  settle" meter-reading form; and live price/quantity filters + sort on
  the buyer's discovered-offers list. Found and fixed a real bug along the
  way: settlement after an accepted counter was still using the buyer's
  original (superseded) bid price, not the agreed counter price. All new
  paths verified against the real live network (curl, then a full pass of
  actual Playwright browser clicks with zero console errors) before
  pushing — commit `aaec42f` in `p2p-trading-demo-app`.
- **Follow-up fix (2026-09-16): a real capacity bug, caught in review.**
  User found the discover cards' "Buy at ask" skipped negotiation entirely
  and the offer ID needed to manually bid wasn't visible on the card at
  all. Tracing the same code path further turned up a worse, unreported
  bug: a published offer's quantity never actually depleted as trades were
  accepted — the same offer could be sold to unlimited buyers. Fixed with
  a real `remaining_qty` balance, checked and decremented at the seller's
  actual accept/counter commitment (rejected if not enough remains,
  released back if a counter is later declined); every card now always
  shows its offer ID with a copy button and a "Place a bid" shortcut into
  the real bid form; "Buy at ask" now re-resolves live instead of trusting
  a cached price/qty. Verified end-to-end against the real network
  (full deplete-to-zero, over-large bid/counter rejection, reservation
  release, regression on decline + blocked-discom) plus a live browser
  pass — commit `20b04a4`.
- **Open step**: the broader feature-roadmap proposal (ask #4, upgrades
  like discom ledger views — explicitly not a tech-stack change) —
  requested long ago, still not started.
- **New**: a combined portfolio deck spanning all three workstreams below
  (UC3, V2G, P2P) — see the note after workstream 4.

### 2a. Full live re-verification of all 12 documented gaps (9 Oct), then 12 more (13 Oct)

At direct challenge ("reverify the already gaps we identified and run a
conformance check whether they are really true gaps"), re-ran the whole
`p2p-trading-ies-wave2` devkit fresh (16-container Docker stack, the real
Arazzo workflow runner) and individually re-tested all 12 then-documented
gaps: **10 confirmed exactly as documented, 1 confirmed live with an
actual working exploit** (a real trade at ₹0.01/kWh cleared every check
the network applies), 2 found already better mitigated than first
believed. Wrote `FEASIBILITY-STUDY.md` and two matching decks
(`p2p-grid-feasibility`/`personal-deg` repos).

Gaps 13–24 added the following week, split between reviewer-prompted
(13–16) and a proactive hunt (17–24). The single most important:
**Gap 16 — no aggregator/VPP role to pool many small offers for one bulk
buyer** — explicitly flagged "arguably the single most commercially
significant idea raised in the whole review," HARD/roadmap-level, not
built at the time it was named.

Four of the twenty-four gaps were then actually fixed and proven live
against the real network (not just documented): a real under-delivery
penalty (was hardcoded `0.0`); a sane min/max price band (closing the
proven ₹0.01/kWh exploit); a non-firm-commitment penalty exemption; and
real cross-DISCOM wheeling charges (also previously `0.0`) — all pushed
as additive patches, never edited into the shared upstream devkit clone.
Full detail, including two real display bugs caught by a direct user
challenge to the live dashboard numbers (traced to the seller dashboard's
own naive math and a stale policy cache, not the real policy engine —
both fixed), is in `logbook.md`'s 2026-10-13 entry.

### 2b. The aggregator: built, rebuilt properly, given its own demand-first dashboard, then stress-tested until it broke

Directly answering Gap 16: built a first working **aggregator-app**
(pools small sellers' offers into one block, publishes it, disaggregates
settlement proportionally back to each seller — verified to the rupee).
Real use immediately found 2 real problems no code review had caught:
unhelpful generic error messages hiding real NACK reasons, and a genuine
security gap letting offers that didn't belong to this seller be pooled
and resold from the wider shared network. Both fixed; role-clarity
banners added to all three dashboards.

Rebuilt properly as **Aggregation v2** after a direct structural
objection — the aggregator's own block was showing up inside seller-app's
dashboard, contradicting "sellers never see the aggregator." Researched
FERC Order 2222 and the UK's Piclo Flex directly, confirming real DER
aggregation is demand-first and individual resources never transact under
their own identity in any real model. Gave the aggregator its own
independent onix adapter instance and catalog — reusing seller-app's
already-registered signing keys (Beckn genuinely decouples signing
identity from routing address, confirmed directly from the real onix
config; no new DeDi registration needed) — added demand-first matching
(a `requirements` table, a cheapest-first `recommend` endpoint that
honestly flags any shortfall), and a brand-new **fourth dashboard,
`grid-app`** (the demand/DISCOM side). Found and fixed a load-bearing bug
in `buyer-app/beckn.js` along the way: `buildInit()` hardcoded the
seller's routing address for every purchase, which would have made the
whole separation invisible to the buy side.

**Phase 2**: gave `grid-app` its own independent onix identity too, so it
(not buyer-app) now discovers and buys the block that fulfills its own
posted requirement — directly closing a gap the user named explicitly
("grid-app posts a requirement but buyer-app is the one that actually
buys it"). Confirmed via onix's own routing mechanics that zero changes
were needed on the seller/aggregator side at all.

**A full live bug-hunt, much of it self-directed rather than reported**,
found and fixed: a recurring UI bug *class* (a 5-second dashboard poll
silently wiping an in-progress click or typed value) in four separate
places, including one genuine double-buy race; a real regression
Playwright itself caught (buyer-app's `/api/my-offers` never checked
aggregator-app's own catalog, permanently hiding its own Buy button); and,
after the user named a suspected bug and asked to verify rather than
trust it, a genuine requirement-deadlock — an aggregator publishing less
than a grid requirement needed left that requirement stuck forever, since
there was no way to top it up later. Fixing that surfaced three more real
bugs testing it: an offer could in principle be double-pooled into two
blocks; a block's final price was never checked against a buyer's own
stated price ceiling (proven live — a buyer silently overpaid); and the
pooling safety minimum wrongly blocked a legitimate later top-up. **All
fixed**: a requirement can now be fulfilled by more than one block over
time, a ceiling-violating publish is hard-rejected, and the pooling
minimum relaxes correctly for a genuine top-up.

### 2c. What's genuinely still missing for a real rollout (researched 2026-10-15, with current sources)

Not hypothetical: REC Limited demonstrated a live Beckn-based P2P trade
(a real farmer near Meerut selling to a real shop owner in Delhi) at the
India AI Impact Summit, February 2026, shown to the Prime Minister; DERC
cleared a real six-month pilot the same month at ₹0.42/kWh split
buyer/seller. What's still genuinely missing before any of this could be
real at scale, in priority order: **real metering** (this demo's
"delivered reading" is still a typed-in number), real per-participant
identity verification (nothing stops a fake prosumer "publishing" energy
with no real net-metered installation behind it), a real payment rail, a
real dispute/grievance process, and a settled regulatory path
specifically for the aggregator's own role — which does not yet fully
exist even within the real pilot programmes (India has draft VPPA
guidelines and draft state-level DER-aggregator definitions, but no
settled aggregator licensing regime). Full sourced write-up published as
a standalone reference artifact.

### 2d. Standing reference documents

- `p2p-trading-app/KNOWLEDGE-BASE.md` — the full architecture/operations
  reference (stack diagram, hop-by-hop message flow, policy-cache
  gotchas, verified settlement math, a post-restart operational
  checklist, a glossary) — written 14 Oct after a cold-restart incident,
  specifically so that diagnosis never has to be rebuilt from scratch.
- `GITHUB REPO/p2p-grid-feasibility/SOFTWARE-GAPS.md` and
  `personal-deg/p2p-energy-trading-review/P2P-Gaps-Defense-Prep.md` —
  the full 24-gap list with conceptual fixes, plain-language
  translations, and before/after examples.

## 3. Nharuvi real-network Beckn identity (nharuvi.com)

Registered a real identity on the real, shared DeDi/Beckn registry —
`did:web:www.nharuvi.com`, a real Ed25519 signing keypair, a live
deployed endpoint (`https://www.nharuvi.com/api/beckn/v1`) — and proved
it works with a real self-signed, self-verified round trip over the
actual internet (valid signature → 200 ACK; tampered body → 401
rejected). A second identity, `bpp.nharuvi.com` (BPP role), was also
registered on the same registry, specifically to test whether adding a
second participant would populate real network membership.

**Status: half-built, currently paused. Re-verified 2026-09-07 — still
exactly where it was left, with the technical reason now fully
understood. No further work since; unchanged through 2026-10-15.** The BAP half is real and proven. The BPP half is
registered but **has no real server behind it** — its registered
callback URL still points at the BAP's own endpoint. Real, confirmed
blockers, and what they actually require to unblock:
- **Getting referenced into an actual IES network** requires a manual
  **email** (not a portal) to `IES.Secretariat@fsrglobal.org` — never
  attempted. Confirmed 2026-09-07 from the real source: no fixed
  template, but an exact checklist of fields (identifier, DeDi
  namespace, lookup URL of a Registry or Record, target network — the
  `test-` variant first, e.g. `test-ies-der-integration-network` — role,
  service areas, contact). Also confirmed directly: approval requires
  **no separate bilateral handshake** with anyone — it only grants
  discoverability, not a forced trade. This was never blocking a demo
  with a third party anyway, since the actual plan has always been to
  run both sides (`www.nharuvi.com` BAP, `bpp.nharuvi.com` BPP)
  ourselves.
- A self-operated network (`test-nharuvi-v2g-network`, created under the
  self-service "NFO" role — no invitation needed) was built and both
  identities added to it, but publishing a reference record **never
  populated either identity's own `network_memberships` field** —
  confirmed by direct, repeated API polling, not a delay, and
  **re-confirmed live on 2026-09-07** (still `[]` on both, `updated_at`
  frozen since creation). Now confirmed *why*, from the real ONIX/NFH
  docs: this field is a genuine authorization gate (not cosmetic) but
  is **not part of the subscriber record's own editable schema** —
  it's backend-managed, and the docs say the only way to get it set is
  to contact NFH support directly. A support query was raised with
  DeDi/NFH about exactly this (their Google Form is the live lead); §1.8
  of the official setup guide also points at a separate, still-unread
  **"network manifest"** concept as likely the actual missing piece for
  self-operated networks specifically.

**Next step (planned, approved, not yet executed):** stand up two real,
always-on `onix` adapters on Fly.io (reusing the exact sandbox images and
config pattern from workstream #2, not new hand-written protocol code),
one per identity, then re-run the same trade sequence for real — this
answers the one question left genuinely open on 2026-09-01: whether a
**direct** exchange between two already-known identities (skipping
broadcast `discover` entirely) works even without network membership.
Blocked right now only on Fly.io authentication — `flyctl` is installed,
but `fly auth login` needs a Personal Access Token from
`fly.io/user/personal_access_tokens` (interactive browser login doesn't
work in this environment). Full plan and exact quotes: `logbook.md`,
2026-09-01 and 2026-09-06 entries.

## 4. V2G / Bosch business exploration

Explored, for a hypothetical "Bosch"-like company, where Vehicle-to-Grid
(V2G) actually fits in the IES/DEG/Beckn ecosystem — concluded V2G itself
has no real spec anywhere in DEG (the pieces exist — `EV_V2G`,
`DER_CONTROL` consent — but nobody has ever wired them together into one
working example), while the separate `Demand_Flexibility` devkit already
does the underlying job (utility pays for measured load reduction) with
real, working settlement math, regardless of what causes the reduction.
Produced three increasingly-scoped presentation decks as the audience's
questions got more technical (a 25-slide general proposal → an 11-slide
demo centered on one concrete scenario → a 14-slide deep-dive on the
ISO 15118-20 vehicle↔charger protocol layer specifically, once the
mentor/team asked to understand that layer too).

**Status: research/case only for V2G itself, no reference-implementation
build started — unchanged since Week 3. A research deck
(`Aggregation-Orchestration-V2G.pptx`) was added 24 Sep. See workstream 5
below for the separate, actually-built demand-flex/aggregation work this
research fed into.**
- Write-ups: `v2g-case.md` (root), `V2G.docx`, `presentation/IES-V2G-PoC-*.pptx`,
  `presentation/ISO-15118-20-Layer-B-Deep-Dive.pptx`,
  `aggregation-v2g/research-bosch-v2g-der-deep-dive.md`.
- Explicitly scoped as a case to weigh, not a decision to build — same
  posture as UC3 before it was built.
- **Open step, if pursued:** a small reference implementation proving
  `EV_V2G` enrollment → `DER_CONTROL` consent → a Demand Flex settlement
  actually composes correctly end-to-end (nobody has shown this) — note
  the *separate* `demand-flex` devkit (not V2G-specific) already has this
  kind of settlement working for a non-EV resource; see workstream 5.

## 5. Demand-Flex / Flexibility Trading, Flex Pulse, and a real MATLAB power-flow model (new, 6–8 Oct)

A separate real government devkit (`demand-flex` — general flexibility/
demand-response, not EV/V2G-specific) explored in real depth after several
genuine misunderstandings were caught and corrected ("capacity requested"
is a restraint on how much a resource may be asked to reduce by, not
power already flowing; price is per kWh, not per kW, and must be
multiplied by the real event duration).

**Status: a second full real trading demonstration built, tested, and
proven, independent of workstream 2's P2P devkit — plus a genuinely
standalone, from-scratch power-flow simulation.**

- **Flex Pulse** (`flex-pulse.html`) — a full Grid-Pulse-style hop-by-hop
  protocol visualizer for this different devkit, hosted live at
  `nharuvi.com/beckn/flex-pulse`.
- An interactive step-by-step walkthrough and a statistics-based pooling
  simulator (`aggregation-pool-simulation.html`, defaults to CERC's real
  1 MW minimum bid size), both hosted at `nharuvi.com/beckn/*`.
- A real settlement bug corrected by actually running the real policy
  through OPA rather than reasoning about it: a negative (export) meter
  reading does **not** floor to zero, it inflates the computed delivered
  quantity — the earlier "floors at zero" claim was wrong.
- **`GITHUB REPO/p2p-grid-feasibility`** — a genuine MATLAB
  backward-forward-sweep power-flow solver for a representative 10-bus
  feeder (standard DistFlow method, no licensed toolbox needed), built
  the same day it was raised; 8 documented software gaps with concrete
  schema/rule fixes; a live Simulink dashboard wired to the real,
  running p2p-trading-demo-app via a masked-icon-redraw technique.
- **`GITHUB REPO/demand-flex-aggregation-demo`** — a real N-customer pool
  event, empirically validated against the real statistical formula
  across pool sizes 3–100; rebuilt, after direct feedback it "doesn't
  look like real trading," into two separate real apps (`tpddl-app` the
  utility, `greenflex-app` the aggregator) communicating over real signed
  protocol messages, with a persistent subscriber registry (40 seeded
  customers), live simulated fleet telemetry, and real per-subscriber
  payout splitting. Connected to a real, user-visible MATLAB session via
  the official MATLAB MCP server. A full Playwright click-through found
  and fixed several more real bugs (silent validation failures, a
  negative-number acceptance bug, the same 5-second-poll-wipes-state bug
  pattern later also found in the main P2P app, missing double-submit
  guards).
- `GITHUB REPO/demand-flex-demos` — companion walkthrough/calculator
  material (mirrored on `nharuvi-new-main`), later revised to drop an
  overclaiming "verified-live" badge and spell out the settlement math
  step by step.

## 6. Presentations & records built for team review (UC3 + V2G + P2P)

A team-review deck spanning workstreams 1, 2, and 4 above went through
three real revisions after direct user feedback, plus a separate living
work-record, plus a from-scratch illustrated version of Grid Pulse for
audiences who won't sit through a live demo. All of it was eventually
pushed to a **new private repo**, `github.com/Sanjay-dev22/personal-deg`.

**Portfolio deck — done, two versions kept:**
- v1 (`DEG-IES-Portfolio-Overview.pptx`) — first draft, 6 slides. User
  caught real problems: too-condensed DEG/IES intro, and several
  **private details that leaked in** (a "PRIVATE REPO, NOT SUBMITTED"
  status label, internal filenames, exact deck counts). **Superseded and
  deliberately excluded from the final repo push** — never revealed
  further.
- v2 (`DEG-IES-Story-v2.pptx`) — rebuilt at 21 slides: full multi-slide
  DEG/IES intro (matching the original UC3 deck's own depth), every
  private/internal reference stripped, reframed as personal narrative
  ("what I did") rather than a company pitch.
- Compact (`DEG-IES-Story-Compact.pptx`) — user then asked for fewer
  slides after all; condensed to 7 (2-slide intro + one slide per
  workstream + closing), keeping the privacy-safe framing.

**Weekly work record — done, three formats, same content:**
- `DEG-IES-Work-Record.pptx` — a living, one-slide-per-week deck meant to
  be added to over time as new milestones happen.
- `Work-Record-Weekly.docx` — the same period as full narrative prose,
  meant to be submitted as a real timesheet/worksheet.
- `Work-Record-Summary-Bullets.md` — the same again, condensed to
  precise bullets only, for pasting into a team OneNote/SharePoint page.
- All three cover 14 Aug – 8 Sep, week by week, with **zero mention of
  our own tooling** (no repos, no logbook/summary, no filenames) per
  explicit instruction — only real research/engineering substance.

**Grid Pulse, illustrated — done, real bugs found and fixed by actually
looking:**
- `Grid-Pulse-Guided-Tour.pptx` — real screenshots + real payloads from
  the live tool, 6 of the 31 real hops, non-linear (a clickable map jumps
  to any moment, native PowerPoint slide-jump links, no macros).
- `Grid-Pulse-Illustrated-Tour.pptx` — same 6 moments, but every visual
  hand-drawn from native shapes instead of screenshots (gradient nodes, a
  small consistent icon language, flow arrows with a moving-packet dot).
- **Real capability unlocked this pass**: PowerPoint COM automation
  (`New-Object -ComObject PowerPoint.Application`) to actually export and
  look at rendered slides — earlier checks for PowerPoint had failed on
  a wrong path guess. Found genuine bugs invisible to coordinate math
  alone (a status badge rendered on top of another label, a caption
  overlapping the settlement graphic, a duplicated badge, a diagram
  overflowing off its own panel into illegible text) — all fixed and
  re-verified by rendering again, not just re-checking math.
- Added a 12th "journey recap" slide tying all six moments into one
  sequence, per the user's ask to extend it further.

**Personal archive — done.** All of the above (except the flawed v1
portfolio deck) plus the four original decks (`IES-TSP-Proposal.pptx`,
`IES-V2G-PoC-Proposal.pptx`, `IES-V2G-PoC-Demo.pptx`,
`ISO-15118-20-Layer-B-Deep-Dive.pptx`) and their supporting write-ups
pushed to a **new, private** repo: `github.com/Sanjay-dev22/personal-deg`
(confirmed private via `gh repo view`), organized into
`portfolio-deck/`, `grid-pulse/`, `work-record/`, `original-decks/`.

### 6a. Everything built since (updated 2026-10-15)

- **Master Portfolio deck, combined, 3 rounds (16–17 Sep)** — mentor
  supplied a real template (`sample.pptx`); rebuilt from v1 (too
  AI-sounding, leaked private detail) → v2 (too plain) → v3 (boxed/
  tinted, final) — `DEG-IES-Master-Portfolio.pptx`, 26 slides, pushed
  `e3187fa`.
- **Grid Pulse Illustrated Tour** — fully hand-drawn (not screenshot)
  version; 5 real layout bugs found only by actually rendering it via
  PowerPoint COM, the capability unlocked this same pass and used for
  every deck since. Extended with a 12th "journey recap" slide.
- **Two intro slides** for a department meeting (21 Sep).
- **Aggregation-Orchestration-V2G.pptx** (24 Sep) + its research write-up.
- **A real team presentation, given live (29–30 Sep)** — the Master
  Portfolio deck trimmed, with full speaker notes added end-to-end, for
  a genuine group presentation the next day covering UC3 + V2G + P2P
  together in plain, non-technical language — the first time all three
  workstreams were presented together to a group beyond the immediate
  reviewing circle (`DEG-IES-Presentation-15min.pptx`). Live demo
  dashboards hosted the same day for the team to click through.
- **UC3 defense-review prep** (5–6 Oct) — a real, in-person review on
  5 Oct where reviewers said the proposal read as machine-generated, with
  a tougher follow-up expected the next day.
- **P2P Energy Trading Study + Software Gaps decks** (8–9 Oct), presented
  live to the team on 9 Oct including non-technical members — the decks
  built via `pptxgenjs` instead of `python-pptx`; one real near-miss
  accuracy bug self-caught (a paraphrase dressed as a verbatim quote,
  corrected before the user saw it).
- **P2P Gaps Defense Prep** (`.md`, 13 Oct) — full rehearsal document for
  all 24 gaps, with real-world precedent for the hardest one to accept
  (the shared-ledger single point of failure).
- **P2P Energy Trading Foundations, dark + light theme** (15 Oct) — with
  full speaker notes added to both afterward, matching the
  Aggregation-Orchestration-V2G deck's visual style for the light
  version.
- **This work record itself** (`work-record/`, all three formats) —
  brought current through Week 10 / 15 Oct on 2026-10-15, after being
  stale at Week 4 / 8 Sep for over five weeks; reconstructed directly
  from this session's own `.jsonl` transcript (its sixteen embedded
  compaction-boundary summaries) rather than from memory.

- **Open step, unrelated to the above:** the feature-roadmap proposal
  for the P2P demo app (ask #4 from workstream 2 — upgrades like discom
  ledger views, explicitly not a tech-stack change) — requested, still
  not started.

---

## Where things physically live now (updated 2026-10-15)

- `p2p-trading/` — active workspace for workstream #2's original scripted
  demo (RUNBOOK, guides, demo logs), plus `DEG-repo/` — the **working**
  devkit copy (a sparse clone of the real upstream `beckn/DEG`, local
  config/compose/Caddy edits only, never committed/pushed there) that the
  live Docker stack for both the P2P and demand-flex devkits actually
  runs from.
- `p2p-trading-app/` — the real, live, interactive demo apps: `seller-app`
  (4002), `buyer-app` (4001), `aggregator-app` (4003), `grid-app` (4004,
  new — the demand/DISCOM dashboard), plus `KNOWLEDGE-BASE.md` (the
  standing architecture/operations reference) and `ARCHITECTURE.md`
  (historical pre-build design, superseded).
- `ies-uc3-policy-as-code/` — the current, active UC3 submission repo
  (see workstream 1); older `ies-prototype/`/`ies-submission` now
  superseded.
- `nharuvi-new-main/` — the live production site (hosts workstream #2's
  public pages, Flex Pulse, and the demand-flex tools; its own git
  history holds all of workstream #3).
- `nharuvi-energy-identity/` — local-only real key material for
  workstream #3 (not git — handle with care).
- `GITHUB REPO/` — every repo created purely to be pushed to GitHub in
  isolation: `grid-pulse`, `ies-prototype`, `ies-submission`,
  `p2p-trading-live-demo`, `p2p-trading-demo-app`, `personal-deg`,
  `p2p-grid-feasibility`, `demand-flex-aggregation-demo`,
  `demand-flex-demos`, `flex-pulse` — kept separate from active work.
- `ies-devkit/`, `beckn-onix-src/`, `ies-accelerator/` — read-only
  upstream reference clones (`beckn/DEG`, `beckn/beckn-onix`,
  `India-Energy-Stack/ies-accelerator`) — not our own work, but each was
  directly load-bearing at some point (`beckn-onix-src` in particular is
  what settled the real Ed25519-vs-xed25519 signing-scheme question for
  workstream #3, and later the real onix routing-mechanics questions for
  workstream #5). No other project file currently references any of the
  three by path — safe to delete if disk space matters, otherwise worth
  keeping as fast local reference.
- `research/`, `presentation/`, `session transcripts/` — supporting
  material, spanning all workstreams above.
- `_backups/` — filesystem snapshots taken before risky rebuilds (e.g.
  `2026-10-15-pre-aggregation-v2/`), kept alongside matching git tags in
  `p2p-trading-demo-app` (`v1-buyer-seller-base`, `v2-aggregator-dashboard`)
  — do not delete without explicit instruction, they're the rollback path.
