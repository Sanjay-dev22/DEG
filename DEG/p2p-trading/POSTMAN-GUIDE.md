# The Postman Deep-Dive Guide — Send the Real Beckn Calls Yourself

**A complete, standalone hands-on lab: no prior networking, protocol, or
programming knowledge assumed.** By the end, you will have personally sent
every major request in the P2P energy trading demo — publish, discover,
init, confirm, settle, and the rejected trade — through Postman, against
the real running software the demo's recording came from, understood
every single field in every request and response body, and know exactly
which parts of this are genuinely real versus which parts are local test
fixtures.

This document doesn't assume you've read anything else first. Everything
you need — what Beckn is, how the network is shaped, what each field
means, what's real versus simulated — is explained here, in order.

---

## Part 1 — The mental model (read this once, before touching Postman)

### 1.1 The problem this solves

Today, if you have rooftop solar and generate more power than you use,
there's no easy, trusted way to sell that extra power directly to a
stranger who happens to be on a *different* electricity company's grid.
This demo is a real, working answer to that: a shared set of rules any
electricity company's own software can plug into, so a trade like that
can happen automatically, safely, between two companies that have never
talked to each other before.

**Beckn** is the name of that shared rulebook — not a company, not an app,
just an agreed, open message format that lets independently-built computer
systems talk to each other reliably. **DEG (Digital Energy Grid)** is
Beckn's rulebook written specifically for buying and selling energy.
**IES (India Energy Stack)** is the actual, real, live test network this
demo's messages travel on — you'll see its real web address,
`indiaenergystack.in`, inside every message.

### 1.2 The shape of the network

Every participant in this demo is built the same way, in two layers:

- **The app** (`BuyerApp`, `SellerApp`) — the actual trading platform,
  the software that makes the business decision ("I want to buy this").
- **The onix adapter** — a separate piece of software sitting in front of
  the app, whose only job is security and translation: checking who a
  message really came from, checking it's filled in correctly, checking
  it against this company's own trading rules, signing it, and routing it
  to the right address.

**This is the single most important thing to understand before you send
your first request:** every request you fire in this guide targets your
own side's adapter, never the other company's containers directly, and
never the wider network directly either. You hand your adapter a plain,
unsigned message; it does everything else — cryptographic signing,
policy checks, and delivery — completely on its own.

Sitting between the two sides is **`beckn-router`** — a plain reception
desk. It reads the address on an envelope and forwards it; it never opens,
checks, or modifies anything.

### 1.3 The one idea that makes async responses make sense

Think about ordering food on a delivery app. You tap **Confirm**. You
instantly see **"Order placed ✓"** — that's not the restaurant saying yes,
just the app confirming your tap arrived. A few minutes later, the
*restaurant* sends a **separate, new** notification: "Order accepted."

Beckn works exactly like this, for real:

1. You send `confirm`. The other side's adapter replies **instantly**
   with a tiny `{"status":"ACK"}` — "message received," nothing more.
2. Separately, moments later, that side's adapter starts a **brand-new
   outbound call**, carrying `on_confirm`, addressed back to you.
3. Your adapter receives that, sends its own ACK, and *then* hands the
   real content to your app.

So `confirm`/`on_confirm`, `init`/`on_init`, and `status`/`on_status` are
always **two separate HTTP calls, going opposite directions, at different
times** — never one round trip. You'll watch this happen for real in
Part 6.

### 1.4 The checkpoints every message passes through

Every message, in or out, walks through a short checklist inside the
adapter — like airport security booths, where not every booth has
something to do for every traveller:

| Checkpoint name (what you'll see on screen/in logs) | What it actually does |
|---|---|
| `validateSign` | Checks the sender's digital signature against their real public key, looked up from a registry (Part 8.4 explains this registry is real) |
| `checkPolicy` | Runs a **network-wide** policy check — the same rulebook, evaluated for every message on this network, regardless of who sent it (Part 8.6 shows you this exact, real, public rulebook file) |
| `addRoute` | Looks up the correct next address to deliver this to |
| `validateSchema` | Checks the message's shape is structurally correct against the real published schema documents (Part 8.5 shows exactly how this is verified) |
| `contractpolicyenforcer` | Checks *this specific trade* against a **per-trade** policy document linked from inside the message itself — the only checkpoint that computes the real settlement math, and the only one that can reject a trade for breaking a company's own trading rules (Part 8.7 shows you the real, public policy file that does this) |
| `sign` | Signs the outgoing message with your own adapter's private key |
| `degledgerrecorder` | Forwards a copy of the trade to the relevant record-keeping ledger service(s) |

A checkpoint that ran but had nothing to do for a particular message
("dimmed") isn't a bug — it just means that check doesn't apply to that
kind of message (a plain search, for instance, has no trading rules to
enforce yet).

You now have everything you need conceptually. Parts 2–7 are the actual
hands-on lab.

---

## Part 2 — What the Postman collections actually are (and whether they're real)

Short answer: **yes, genuinely real.** Not a simplified teaching version —
the same devkit configuration (same hostnames, ports, network name, test
prices) that produced the real captured run this whole demo is built from.

### Where they live

Inside the devkit repo, under
`devkits/p2p-trading-ies-wave2/uc1/postman/`, six ready-made files, one
per participant:

| File | Who you're pretending to be |
|---|---|
| `p2p-trading-ies-wave2-uc1.SELLER-DEG.postman_collection.json` | The seller's trading platform (publishes the offer, sends the real answers: `on_init`, `on_confirm`, `on_status`) |
| `p2p-trading-ies-wave2-uc1.BUYER-DEG.postman_collection.json` | The buyer's trading platform (searches, initiates, confirms, asks for status) |
| `p2p-trading-ies-wave2-uc1.SELLERDISCOMLEDGER-DEG.postman_collection.json` | The seller's electricity company's own record-keeping system |
| `p2p-trading-ies-wave2-uc1.BUYERDISCOMLEDGER-DEG.postman_collection.json` | The buyer's electricity company's own record-keeping system |
| `p2p-trading-ies-wave2-uc1.SELLERDISCOM-DEG.postman_collection.json` | The seller's electricity company itself (a dormant participant this demo doesn't exercise live) |
| `p2p-trading-ies-wave2-uc1.BUYERDISCOM-DEG.postman_collection.json` | The buyer's electricity company itself (the other dormant participant) |

### Where these files come from

A small generator script, `scripts/generate_postman_collection.py` (with a
devkit-specific wrapper at
`devkits/p2p-trading-ies-wave2/scripts/generate_postman_collection.py`),
reads one shared configuration block for this devkit — real hostnames
(`buyerapp.example.com`, `sellerapp.example.com`), real ports (`8081`
through `8086`), the real test network name — and mechanically produces
these six files from it. A `generate.sh` script regenerates all six if a
maintainer ever changes the configuration.

**What this proves:** these aren't hand-written demo props. Open any of
them and you'll find the same real numbers everywhere in this demo — the
two price bands (₹12.5 and ₹14.5 per kWh), the requested quantities (20.5
and 15.5 kWh), the same test company names (`TEST_DISCOM_BUYER`,
`TEST_DISCOM_SELLER`), even the same real policy-document URL. This is
the genuine, reproducible way to manually recreate the demo yourself.

### What one click actually reproduces

**You are not manually recreating every hop.** When you send one of these
requests, you're providing only the *first* hop — the moment your app
hands its message to your own adapter. From there, the adapter does
everything else by itself: signing, forwarding across the network, the
other side's adapter verifying and checking it, handing it to their app,
and — for `init`, `confirm`, and `status` — that side automatically
sending the real answer back, within a second or two, exactly like the
recording.

So: **one Postman click reproduces an entire multi-hop flow, for real.**
The extra "answer" requests in the SELLER collection (`on_init`,
`on_confirm`, `on_status`) exist so you can *also*, optionally, send that
exact answer yourself by hand — not because the network needs you to.

---

## Part 3 — Prerequisites

You need three things installed, and one thing running.

### 1. Docker Desktop

The whole demo is roughly a dozen containers running on your own machine.
Install it from [docker.com](https://www.docker.com/products/docker-desktop/),
start it, and wait until it shows fully running.

### 2. Postman

Install the free desktop app from
[postman.com/downloads](https://www.postman.com/downloads/), or use the
web version at [postman.com](https://www.postman.com). A free account is
enough.

### 3. The devkit's actual code

You need a real copy of the `p2p-trading-ies-wave2` devkit on your own
machine. If you're using the companion `p2p-trading-live-demo` repo, its
`setup.sh` sparse-clones exactly what you need into `DEG-repo/`, including
`DEG-repo/devkits/p2p-trading-ies-wave2/`. If you have a full clone of the
upstream `beckn/DEG` repo, the same folder already exists at
`devkits/p2p-trading-ies-wave2/` — adjust the leading `DEG-repo/` in the
paths below if yours differs.

### 4. Start the real network

```bash
cd DEG-repo/devkits/p2p-trading-ies-wave2/install
docker compose up -d
```

Wait ~20 seconds, then:

```bash
docker compose ps
```

Every container — `beckn-router`, `onix-buyerapp`, `sandbox-buyerapp`,
`onix-sellerapp`, `sandbox-sellerapp`, the ledger and discom containers —
should show `Up`. If any show `Restarting`, wait a few more seconds and
check again.

**Quick map**, so the URLs below make sense at a glance:

| Port on your machine | Container | Role |
|---|---|---|
| `8081` | `onix-buyerapp` | Buyer's adapter |
| `8082` | `onix-sellerapp` | Seller's adapter |
| `8083` | `onix-ledger-sellerdiscom` | Seller's electricity company's ledger adapter |
| `8084` | `onix-ledger-buyerdiscom` | Buyer's electricity company's ledger adapter |
| `8085` | `onix-buyerdiscom` | Buyer's electricity company itself (dormant this walkthrough) |
| `8086` | `onix-sellerdiscom` | Seller's electricity company itself (dormant this walkthrough) |
| `9000` | `beckn-router` | The reception desk — only containers talk to this directly; you never call it yourself |

When done: `docker compose down` from the same folder stops and removes
everything cleanly. Nothing persists between runs on your own machine
unless you specifically set that up.

---

## Part 4 — Importing the collections

1. Open Postman, click **Import** (top-left, or **File → Import**).
2. Drag in, or browse to, all six `.json` files from
   `DEG-repo/devkits/p2p-trading-ies-wave2/uc1/postman/`. Postman imports
   each as its own separate collection.
3. In the left sidebar under **Collections**, you'll see six new entries.

**You do not need a separate Postman "Environment."** Each collection
file carries its own bundled default values — Postman calls these
**collection variables** — and they load automatically on import. To view
or edit them: click the collection's name, then the **Variables** tab.

---

## Part 5 — Anatomy of a request and its response, field by field

Open **BUYER-DEG → confirm → confirm-request** and follow along — every
field described here appears, in the same shape, across every request in
every collection.

### 5.1 Method, URL, and headers

**Method** is almost always `POST` (you're submitting a message);
`discover` is the one `GET` (see 6.2).

**URL** is always one variable plus a plain path, e.g.
`{{bap_caller_url}}/confirm`, resolving to
`http://localhost:8081/bap/caller/confirm`. Notice this always points at
**your own** side's adapter, on your own machine — never at the other
company's containers, and never at any wider network address. That's the
rule from Part 1.2, in practice.

**Headers** — every request ships with an empty header list. That's
intentional, not a mistake: Postman auto-adds `Content-Type:
application/json`, and that's the only header you need. **You never
construct a signature or auth header yourself** — that's the adapter's
`sign` step (Part 1.4), which stamps your plain message with the real
cryptographic signature after you hand it over.

### 5.2 The `context` block — the outside of the envelope

Every request body starts with a `context` object. Here is every field
you'll see in it, across all six collections, explained:

| Field | Example value | What it means |
|---|---|---|
| `networkId` | `indiaenergystack.in/test-ies-p2p-trading-network` | Which **named, shared rulebook** this message claims to follow — see Part 8.2, this is *not* the same thing as the URL you're sending to |
| `version` | `2.0.0` | The Beckn protocol version this message is written against |
| `action` | `confirm`, `on_confirm`, `catalog/publish`, ... | The Beckn "verb" — what kind of message this is |
| `bapId` | `buyerapp.example.com` | The buyer platform's registered identity (Part 8.4 explains where it's actually registered) |
| `bapUri` | `http://buyerapp.example.com:9000/bap/receiver` | The address the buyer's side can be reached at, for the async answer to come back to |
| `bppId` | `sellerapp.example.com` | The seller platform's registered identity |
| `bppUri` | `http://sellerapp.example.com:9000/bpp/receiver` | The address the seller's side can be reached at |
| `transactionId` | a fixed UUID | Ties every message of **this one trade** together, start to finish — every hop in a single trade shares one value |
| `messageId` | `{{$guid}}` — a fresh UUID per send | Unique to just this one message |
| `timestamp` | filled by the pre-request script | When this message was actually sent |
| `schemaContext` | a list of `https://schema.nfh.global/.../context.jsonld` URLs | The exact, real, live schema documents this message's shape will be checked against — see Part 8.5 |

A `discover` message only needs `networkId`, `version`, `action`,
`bapId`, `bapUri`, `transactionId`, `messageId`, `timestamp`, and
`schemaContext` — no `bppId`/`bppUri` yet, because you don't know who the
seller is until discovery finds them.

### 5.3 The dynamic parts, explained

- **`{{$guid}}`** is a **Postman dynamic variable** — it generates a fresh
  random ID every single time you hit Send, so `messageId` is never
  accidentally reused.
- **`{{iso_date}}`** is filled in by a tiny **pre-request script** attached
  to the collection (visible under the collection's **Scripts** tab) that
  runs automatically, silently, right before every request goes out. All
  it does is stamp the current real time into this variable. You don't
  need to do anything for this to work.
- **`transaction_id`** is the one variable that deliberately stays *fixed*
  across every request — it's what ties the whole trade together. If you
  want to run the whole demo again as a genuinely fresh trade, change this
  one value first (collection's **Variables** tab) before you start.

### 5.4 The full variable glossary

Every `{{...}}` placeholder you'll encounter, across all six collections,
in one table:

| Variable | Real value | What it actually is |
|---|---|---|
| `domain` | `indiaenergystack.in/test-ies-p2p-trading-network` | The shared network name substituted into `context.networkId` |
| `version` | `2.0.0` | The protocol version substituted into `context.version` |
| `buyerplatform_id` (`bap_id`) | `buyerapp.example.com` | The buyer platform's registered identity |
| `sellerplatform_id` (`bpp_id`) | `sellerapp.example.com` | The seller platform's registered identity |
| `buyerplatform_host_root` (`bap_host_root`) | `http://buyerapp.example.com:9000` | The buyer's address as written *inside messages* (routed through `beckn-router`, not the port you actually call — see 5.1) |
| `sellerplatform_host_root` (`bpp_host_root`) | `http://sellerapp.example.com:9000` | The seller's address as written inside messages |
| `bap_caller_url` | `http://localhost:8081/bap/caller` | The actual door you POST to, on your own machine, to send something *as* the buyer |
| `bpp_caller_url` | `http://localhost:8082/bpp/caller` | The actual door you POST to, to send something *as* the seller |
| `seller_bap_caller_url` | `http://localhost:8082/bap/caller` | The door SellerApp uses when *it* is the one initiating a message (a seller-pushed `status` update) |
| `transaction_id` | a fixed UUID | Ties every message in one trade together |
| `iso_date` | filled automatically | The current timestamp |
| `ledger_host_buyer` / `ledger_host_seller` | `https://ies-p2p-energy-ledger.beckn.io` | The address of the real, external, internet-hosted ledger service both sides' trades ultimately get copied to |
| `buyer_discom_host_url` | `http://buyer-discom.example.com:9000` | The buyer's electricity company's own platform address, as recorded inside contract data |
| `seller_discom_host_url` | `http://seller-discom.example.com:9000` | The seller's electricity company's own platform address |
| `buyer_discom_subscriber_id` | `buyer-discom.example.com` | The buyer's electricity company's own registered network identity |
| `seller_discom_subscriber_id` | `seller-discom.example.com` | The seller's electricity company's own registered network identity |
| `ledger_buyer_discom_id` / `ledger_seller_discom_id` | `ies-p2p-energy-ledger.beckn.io` | The registered identity of the ledger service, as recorded inside contract data |
| `seller_discom_ledger_id` | `seller-discom-ledger.example.com` | The seller electricity company's *own* local ledger TSP's address, as distinct from the external IES ledger above |
| `buyer_ledger_bpp_caller_url` / `seller_ledger_bpp_caller_url` | `http://localhost:8084/bpp/caller` / `:8083/bpp/caller` | The doors used to send a ledger's own outbound `on_status` push |
| `buyer_ledger_bap_caller_url` / `seller_ledger_bap_caller_url` | `http://localhost:8084/bap/caller` / `:8083/bap/caller` | The doors used for a ledger-initiated `status` request |
| `sellerdiscom_host_root` / `buyerdiscom_host_root` | `http://sellerdiscom.example.com:9000` / `http://buyerdiscom.example.com:9000` | The addresses of the two dormant electricity-company-as-actor participants |
| `sellerdiscom_bpp_caller_url` / `buyerdiscom_bpp_caller_url` | `http://localhost:8086/bpp/caller` / `:8085/bpp/caller` | Their own local calling doors |

Every one of these is a plain string substitution — nothing clever
happens to any of them beyond "replace `{{name}}` with this value before
sending."

### 5.5 The `message` block — the letter itself, field by field

This is the part with the most confusing-looking fields on first read.
Here's every structural field explained, once, so you never have to
wonder about it again wherever it reappears.

**`@context` and `@type`** — these two appear on almost every nested
object (`resourceAttributes`, `contractAttributes`, `participantAttributes`,
`settlementAttributes`, ...). This is a **JSON-LD** convention (a real,
widely-used web standard, not something DEG invented): `@type` names
*which* real, published schema this particular object is claiming to be
(e.g. `"@type": "DEGContract"`), and `@context` points at the actual,
live document defining what every field inside that object is allowed to
mean (e.g. `https://schema.nfh.global/DEGContract/v2.0/context.jsonld`).
It exists so that two completely different companies' software can agree,
unambiguously, on what a field like `"role"` or `"quantity"` means — the
same reason a legal contract defines its terms up front.

**`schemaContext`** (in `context`, not `message`) is the list of every
such schema document this particular message's shape needs to be checked
against, all gathered in one place. This isn't decorative — it's real:
Part 8.5 shows you this list is genuinely fetched and validated against,
live.

**`contract`** — the top-level object for anything past `discover`.
Contains:
- `status.code` — `DRAFT` (still being negotiated), `ACTIVE` (confirmed),
  or `COMPLETE` (settled).
- `id` — the contract's own identifier, appearing once it's confirmed.

**`commitments`** — an array (one entry here, for the one trade), each
with:
- `id` — this commitment's own identifier.
- `status.descriptor.code` — mirrors the contract's own status.
- `resources` — what's actually being traded: an `EnergyResource` object
  naming a real quantity (`quantity.unitQuantity`, `unitCode: "KWH"`) and
  a `resourceAttributes.type` (`SOLAR`).
- `offer` — links this commitment back to the original published offer
  by its `id`.
- `commitmentAttributes` — a `TimeSeries` object (another real, published
  schema type) describing *when* this applies (`intervalPeriod`) and
  *what numbers* are attached to which time slot:
  - `payloadDescriptors` — declares, up front, which kinds of numbers
    will appear in the `intervals` below, and whose job it was to write
    each one (`insertedBy`) — e.g. `PRICE_PER_KWH` is always written by
    the seller platform, `REQUESTED_QTY` by the buyer platform,
    `FINAL_ALLOC` (the real delivered amount) later by the seller's own
    discom. This is what lets the network's shared policy (Part 8.6)
    check that every required number is actually present, without
    needing to know anything about energy trading specifically — it just
    checks the *shape*.
  - `intervals` — the actual numbers, one entry per time slot (`id: 0`,
    `id: 1`), each carrying a small array of `{type, values}` pairs
    matching the descriptors above.

**`contractAttributes`** — a `DEGContract` object, containing:
- `roles` — the four real participants named explicitly:
  `buyerPlatform`, `sellerPlatform`, `buyerDiscom`, `sellerDiscom`, each
  with a `participantId`. This is how the network-wide policy (Part 8.6)
  checks things like "the buyer's and seller's electricity companies must
  actually be different" without needing separate fields for it.
- `policy` — `{url, queryPath}`. This is not just a reference document —
  it's a **live pointer to real, executable policy logic** that gets
  fetched and run against your message. Part 8.7 shows you exactly what
  this does and why it's the single most important field in the whole
  demo.

**`participants`** — a flat array giving each named role's actual
contact details: `EnergyCustomer` objects for the two platforms (meter
ID, customer ID, `platformUrl`), and `DiscomLedgerProvider` objects for
the two electricity companies (`discomId`, `discomUri`, `ledgerId`,
`ledgerUri` — literally the address the ledger cascade in Part 6, Step 4
gets copied to).

**`settlements`** — an array describing the payment side. Each entry has
an `id`, a `status` (`DRAFT` → `PENDING` → `COMMITTED` → `COMPLETE`), and
`settlementAttributes`:
- `payTo` — `accountHolderName`, `accountNumber`, `branchCode`,
  `bankName`. **Read this literally: these are fabricated test values**
  ("Seller Platform Pvt Ltd," a made-up account number). Nothing in this
  devkit ever calls a real bank, UPI, or payment gateway API with this
  data — see Part 8.8 for exactly what is and isn't real about this
  field.
- `acceptedPaymentMethods` — a list like `["BANK_TRANSFER"]`, declaring
  which payment rails this settlement term would use in a real
  deployment.
- `paymentTrigger` — `"ON_FULFILLMENT"`, meaning (structurally, in the
  spec) "pay once delivery is confirmed" — again, a real field with a
  real defined meaning, but nothing in this local devkit actually acts on
  it.

**`consideration`** — appears only in the final settled `on_status`
message. Contains `revenueFlows`: the actual computed payment split
(`role`, `value`, `currency`, `description`) — this part genuinely is
computed live, by real policy logic, from the real delivered quantities.
Part 8.7 shows you exactly how.

### 5.6 The response body

A successful call returns:
```json
{ "message": { "status": "ACK", "messageId": "<uuid>" } }
```
`status: "ACK"` means only "received and accepted for processing" — not
"the trade succeeded." A rejected call (Part 6, Step 6) instead returns:
```json
{ "message": { "status": "NACK", "messageId": "<uuid>",
  "error": { "code": "Bad Request", "message": "<human-readable reason>" } } }
```
with an HTTP `400` status, and, critically, a plain-English `message`
string telling you exactly which rule was violated — you'll see this
verbatim in Part 6.

---

## Part 6 — The full walkthrough

Same order as the demo: Publish → Discover → Init → Confirm → Settle →
Rejected.

### 1. Publish

**Open:** `SELLER-DEG` → **publish** → **publish-catalog**
**Method:** `POST` · **URL:** `http://localhost:8082/bpp/caller/catalog/publish`

Click **Send**. You should get `200 OK`, body
`{"message":{"status":"ACK","messageId":"<uuid>"}}` within about a
second. The seller's offer (30.5 kWh across two price bands) is now on
the shared catalog — see Part 8.1 for exactly where "the shared catalog"
physically is.

### 2. Discover

**Open:** `BUYER-DEG` → **discover** → **discover-request**
**Method:** `GET` *(see the note below)* · **URL:** `http://localhost:8081/bap/caller/discover`

Click **Send**. Same ACK shape back. If you'd already run Publish
(above), and depending on what else has been published to this shared
test network recently, you may also get back an actual catalog listing
in the response — Part 8.1 explains precisely why, and where that data
was actually sitting.

> **A quirk worth knowing:** this request is a `GET` that still carries a
> JSON body (the search filter). Normally, tools strip a body off a
> `GET` — but Beckn's `discover` call is specified to include one anyway.
> This collection already has a Postman setting switched on for this
> request (**Settings → Disable body pruning**) so the body survives.
> Nothing to change — just know why this one looks unusual.

### 3. Init

**Open:** `BUYER-DEG` → **init** → **init-request**
**Method:** `POST` · **URL:** `http://localhost:8081/bap/caller/init`

Send it, get the ACK back. That ACK is only "received" (Part 1.3). The
real answer, `on_init`, is generated by the seller's adapter and
delivered back automatically within a second or two. Watch it happen:

```bash
docker compose logs -f onix-sellerapp onix-buyerapp
```

**To send that answer yourself instead of just watching it:** `SELLER-DEG`
→ **on_init** → **on-init-response** (`POST`
`http://localhost:8082/bpp/caller/on_init`).

### 4. Confirm

**Open:** `BUYER-DEG` → **confirm** → **confirm-request**
**Method:** `POST` · **URL:** `http://localhost:8081/bap/caller/confirm`

Send it, get the ACK. The seller's side automatically generates
`on_confirm` — and this is the message that also triggers the real ledger
cascade: a copy to the seller's own electricity company's ledger, and a
separate copy straight out to the real, internet-hosted IES Energy
Ledger. Watch all of it:

```bash
docker compose logs -f onix-sellerapp onix-buyerapp onix-ledger-sellerdiscom onix-ledger-buyerdiscom
```

**By hand instead:** `SELLER-DEG` → **on_confirm** →
**on-confirm-response** (`POST`
`http://localhost:8082/bpp/caller/on_confirm`).

### 5. Settle

**Open:** `SELLER-DEG` → **on_status** → **on-status-response-settled**
**Method:** `POST` · **URL:** `http://localhost:8082/bpp/caller/on_status`

Click Send. Open the **Body** tab on the response and look at
`consideration.revenueFlows`: the real computed `+437.15` / `-437.15`
split. This is the single most important response in the whole demo —
Part 8.7 shows you the exact real policy file that computed it, from the
real delivered quantities in this request's own body
(`commitmentAttributes.intervals[].payloads` with `type: "FINAL_ALLOC"`).

*(The buyer-initiated equivalent: `BUYER-DEG` → **status** →
**status-request** — `POST` `http://localhost:8081/bap/caller/status`.)*

### 6. Rejected

**Open:** `BUYER-DEG` → **init** → **init-request-blocked-discom**
**Method:** `POST` · **URL:** `http://localhost:8081/bap/caller/init`

Same folder, same URL as the real Init — the only difference is inside
the body: `buyerDiscom` is set to `TEST_OUTSIDE_DISCOM` instead of the
approved `TEST_DISCOM_BUYER`. Click **Send**:

```
Status: 400 Bad Request
Body:   { "message": { "status": "NACK", ...
          "error": { "message": "BAD Request: settlement policy
          violations: buyer discom \"TEST_OUTSIDE_DISCOM\" is not
          allowed to trade with this discom's prosumers on the test
          network (allowed: [...])" } } }
```
Unlike every other step here, there's no automatic follow-up to watch —
the rejection is synchronous, in this exact response. Part 8.7 shows you
the real policy rule, by line number, that produced this exact message.

---

## Part 7 — Going further: the ledger and discom collections

**`BUYERDISCOMLEDGER-DEG` / `SELLERDISCOMLEDGER-DEG`** — model each
electricity company's own record-keeping system directly. Their
`on_status` folder (e.g. `http://localhost:8084/bpp/caller/on_status`)
is the same kind of cascade copy Confirm/Settle deliver automatically —
sending it here yourself isolates just that one company's ledger.

**`BUYERDISCOM-DEG` / `SELLERDISCOM-DEG`** — model the two dormant
participants: the electricity companies themselves, as distinct from
their ledger systems, used for meter-data workflows this demo doesn't
exercise live. Included for completeness.

---

## Part 8 — What's real, what's simulated, and where things actually live

This is the part that answers "wait, is any of this actually
real, and if so, which parts?" You deserve a precise, verifiable answer —
not a hand-wave — so every claim below points at an actual file you can
open yourself.

### 8.1 Where `discover` and `publish` actually go — and why discover can return data before you've published anything yourself

Here's the fact that resolves the confusion: **`beckn-router`
(the reception desk, port `9000`) has no route for the catalog or
discover services at all.** Open
`devkits/p2p-trading-ies-wave2/install/Caddyfile` yourself — it only
knows how to reach the two apps, the two ledgers, and the two dormant
discom actors. Nothing catalog-shaped is in there.

So where does `catalog/publish` and `discover` actually go? Open
`devkits/p2p-trading-ies-wave2/config/local-p2p-trading-routing-SellerApp-BppCaller.yaml`:
```yaml
target:
  url: "https://fabric.nfh.global/beckn/"
endpoints:
  - catalog/publish
  - catalog/subscription
```
and `local-p2p-trading-routing-BuyerApp-BapCaller.yaml`:
```yaml
target:
  url: "https://34.93.165.42.sslip.io/beckn" # Replace with your Discover service endpoint
endpoints:
  - discover
```
**Both are real addresses on the real internet — not your Docker
containers, not localhost.** `catalog/publish` genuinely leaves your
machine and lands on `fabric.nfh.global`, a real, shared, hosted service.
`discover` genuinely goes to a real, hosted service running at that IP
address (`34.93.165.42`; the `sslip.io` part is just a convenience DNS
trick that makes an IP address usable as a plain hostname — the traffic
still goes to that one real server). Your adapter's `addRoute` step (Part
1.4) is what looks up and picks these real addresses — you don't type
them anywhere yourself.

**This is why `discover` can return real data before you've personally
published anything in this session:** it's a shared, persistent, real
service on the internet. If this devkit — or anyone else using this same
public test network — has published a catalog entry before, `discover`
can genuinely find it, because it's asking a real, shared database, not
a private local cache tied to your one Docker Compose session.

**If you publish a new offer yourself, does discover find it?** Yes —
you're writing to, and reading from, the same real shared service, so a
new `catalog/publish` genuinely becomes discoverable, subject to that
service's own search-matching logic. And it means, honestly: since this
is a *shared, public test network*, other people's test publishes may
also show up in your own `discover` results. That's expected, not a bug.

### 8.2 Why the `domain` variable says a real network name, even though you're calling `localhost`

This is two genuinely different things, easy to conflate:

- **The literal HTTP address you send bytes to** — always
  `http://localhost:<port>/...`, your own adapter, on your own machine.
- **`context.networkId`** — a *label written inside the message content*,
  declaring which named, shared rulebook this message claims membership
  in and should be validated against.

Why does this distinction need to exist at all? Because a single running
adapter binary could, in principle, serve more than one Beckn network at
once (a test network and a production one, say) — so every message has
to self-declare which network's rules apply, independent of which literal
door you happened to knock on. It's the same idea as a company's
receptionist asking "which department is this for?" even though you
walked in through the one shared front door.

You can see the real network-wide policy (Part 8.6) explicitly checking
this field — `NET1` in the real rego file requires `context.networkId`
to be an exact match against a small allowed set, rejecting anything
else outright.

### 8.3 Is the signing real?

Yes. Open any of the onix config files under
`devkits/p2p-trading-ies-wave2/config/` (e.g.
`local-p2p-trading-buyerapp.yaml`) and you'll find a real `keyManager`
block per participant, carrying a real Ed25519 keypair:
```yaml
keyManager:
  id: simplekeymanager
  config:
    networkParticipant: buyerapp.example.com
    keyId: 76EU8w8ynnqbhderWtVE5KpCmgAoVEXtM8JTCuW3PzUSGdMxtFjzyZ
    signingPrivateKey: TTQMAEy0xJcoRXRNofZAwZq1c3VH6j98UUaHP7budQQ=
    signingPublicKey: g/3swjI93IhZ0SScrVZapeLjU+W0AeiSid3LViYZJFo=
```
These are genuine cryptographic keys, genuinely used to sign every
outbound message and genuinely verified on the receiving side. What's
*not* real-world-production about them is that they're fixed test
fixtures baked into this devkit's checked-in config, rather than keys a
real company would generate and keep private during real onboarding —
appropriate for a public, reproducible test devkit, not appropriate for
an actual production participant.

### 8.4 Is the registry real? What is `subscribers.beckn.one`?

Yes, real. The same config files show:
```yaml
registry:
  id: dediregistry
  config:
    registryName: subscribers.beckn.one
    allowedNetworkIDs: "indiaenergystack.in/test-ies-p2p-trading-network,nfh.global/testnet-deg"
```
`dediregistry` is a real plugin that looks participants up in a real,
shared registry service (`subscribers.beckn.one` — a "DeDi," decentralized
directory, service) to resolve their public signing key and routing
address — the actual mechanism behind `validateSign` and `addRoute` from
Part 1.4. This devkit's participants (`buyerapp.example.com`,
`sellerapp.example.com`, and the two discom ledgers) are already
registered there, as **test-network entries**, which is precisely why
this whole demo already works out of the box without you personally
registering anything.

One config file is candid about the one place this *isn't* fully wired
up: `local-p2p-trading-buyerdiscom.yaml` explicitly comments that the
dormant discom-actor participant has signing turned off, "since ...
the actor's subscriber id (`buyerdiscom.example.com`) is not registered
in the testnet dedi registry. For prod, register the subscriber and
re-enable `signer`." That's the real, honest boundary: the two *main*
trading participants are properly registered test identities; the two
dormant discom-actor participants are stub identities, not registered
anywhere, which is exactly why Grid Pulse and this guide both mark them
"not used this walkthrough."

**This is also the real answer to "what about applying to the IES
secretariat":** that's the real-world process for getting a *new*
identity registered on this registry as a genuine, production-recognized
participant. This devkit's identities are already pre-provisioned
*test-network* entries on the same registry infrastructure — a
convenience for reproducible demos, not a substitute for that
registration process for a real, new participant.

### 8.5 Is the schema validation real?

Yes — and it's not just checking your JSON's syntax is valid, it fetches
the actual referenced schema documents live. Look at the same config
files again:
```yaml
schemaValidator:
  id: schemav2validator
  config:
    cacheTTL: "172800"
    extendedSchema_enabled: "true"
    extendedSchema_downloadTimeout: "30"
    extendedSchema_allowedDomains: "raw.githubusercontent.com,schema.nfh.global"
```
This genuinely downloads (with a 30-second timeout, and only from those
two allow-listed domains) the real JSON-LD schema documents your
message's `schemaContext` list points at, caches each for 48 hours
(`172800` seconds), and checks your message's actual shape against them.
If a required field is the wrong type, missing, or your message claims a
`@type` that doesn't match what it actually contains, this step fails —
and the pipeline turns that failure into a real, synchronous rejection,
the same `400`/NACK shape you saw in Step 6.

### 8.6 The network-wide policy — a real, public file, checked live

Open `devkits/p2p-trading-ies-wave2/config/opa-network-policies.yaml`:
```yaml
networkPolicies:
  default:
    type: file
    location: https://raw.githubusercontent.com/beckn/DEG/refs/heads/main/specification/policies/p2p-trading-ies-wave2-networkpolicy.rego
    query: data.deg.policy.p2p_trading_network.violations
```
This is `checkPolicy` from Part 1.4: it genuinely fetches this exact
`.rego` policy program — written in **Rego**, the real query language
used by the **Open Policy Agent (OPA)**, a widely-used real
policy-as-code engine — straight from the public `beckn/DEG` GitHub repo,
and evaluates it, live, against every single message on the network,
regardless of who sent it. It's the same rulebook for everyone, and it's
sitting in a public repository right now for anyone to read.

A few of the real rules inside it, so you know exactly what it's
checking (not a vague "security scan"):
- Currency on any price must literally be `INR`.
- Quantity units must literally be `KWH`.
- The buyer's and seller's electricity companies must be different (no
  self-dealing between two arms of the same utility).
- The buyer's and seller's meter IDs must differ (no trading with
  yourself).
- `context.networkId` must be an exact match against a small recognized
  set — this is the field from Part 8.2.

Change any one of these in a request body yourself (try setting the
price's currency to `"USD"` instead of `"INR"` in a copy of the confirm
request) and you'll get a real rejection, citing that exact rule — this
policy runs on every message, no exceptions.

### 8.7 The per-trade policy — where the real money math and the real rejection actually come from

This is the single most important field in the whole demo:
`contractAttributes.policy.url`. Open
`devkits/p2p-trading-ies-wave2/config/../..` — specifically, the plugin
source at `plugins/contractpolicyenforcer/contractpolicyenforcer.go`
(part of this same devkit repo) describes exactly what it does:

> *"computes settlement flows from a rego policy referenced by the
> contract ... resolves the rego source ... evaluates it against the full
> message, and writes the resulting flows ... the policy may export a
> `violations` set ... this is how a discom's policy (e.g. an allowlist
> of counterpart discoms ...) blocks non-compliant trades at
> select/init/confirm."*

In plain terms: the `policy.url` field in every trade-shaped message —
which you saw as
`https://api.dedi.global/dedi/lookup/indiaenergystack.in/ies-rulesets/p2p-trading-ies-contractpolicy-common`
— isn't a reference document to read. It's a **live pointer to a real,
executable policy program**, hosted on the real DeDi registry, that this
plugin genuinely fetches over HTTP and runs, using the real OPA engine,
against your actual message, every single time.

The real policy file itself — publicly readable at
`specification/policies/p2p-trading-ies-wave2-contractpolicy.rego` in the
`beckn/DEG` repo — contains both halves of what you watched happen:

- **The rejection you triggered in Step 6**, almost verbatim:
  ```rego
  not _buyer_discom_id in _env.allowed_buyer_discoms
  ```
  — a real allowlist check, per seller-discom, evaluated against whatever
  `buyerDiscom` your message's `contractAttributes.roles` actually names.
- **The settlement math you saw in Step 5**, also almost verbatim, as a
  code comment right above the real calculation:
  ```
  Per-slot trade value = FINAL_ALLOC × PRICE_PER_KWH (matched by interval id).
  Total trade value    = sum across all FINAL_ALLOC intervals.
  ```
  — which is exactly `18.5 × 12.5 + 14.2 × 14.5 = 437.15`, genuinely
  computed by this real program reading the real `FINAL_ALLOC` and
  `PRICE_PER_KWH` values out of your own request body's
  `commitmentAttributes.intervals`, not hardcoded anywhere.

So: yes, a single field change really can get you rejected with no ACK —
and now you know precisely which two real, public files decide that, and
can go read either one, end to end, yourself.

### 8.8 What's honestly *not* real: the payment fields

The `settlements` / `settlementAttributes` object — `payTo`,
`acceptedPaymentMethods`, `paymentTrigger` — is a real, defined part of
the DEG schema (a genuine `SettlementTerm` object, with its own real
published schema at `schema.nfh.global/SettlementTerm/2.0/`). That part
is not fake.

What *is* fake, plainly: the actual values in this devkit —
`"Seller Platform Pvt Ltd"`, account number `0012345678901`, `HDFC0001234`
— are fixture data checked into the example files, not a real bank
account. **No component anywhere in this devkit calls a bank API, a UPI
switch, or any real payment rail.** The `settlementStatus` /
`paymentStatus` fields you see move from `PENDING` to `COMPLETE` because
the example fixtures and the demo's own captured run simply advance them
as part of the recorded story — not because any real payment was
processed and confirmed.

**What a real, production version of this would need, on top of exactly
what you've just used:** a genuine payment-service integration, wired to
fire when `paymentTrigger` conditions are met, that actually calls a real
bank/UPI rail with the real computed `revenueFlows` amount, and then
writes the real transaction outcome back into `settlements[].status`.
The protocol message shape you've been sending is already exactly what
that integration would consume — nothing about the message format would
need to change, only a real payment executor listening on the other end
of it.

### 8.9 What changes if Docker is removed and `localhost` no longer exists

Nothing about the *messages themselves* would need to change — that's
the entire point of building on a shared protocol. What would change:

- `buyerapp.example.com` / `sellerapp.example.com` and their `:9000`
  addresses are this devkit's **local stand-ins** for what would, in
  production, be a real company's own real, public hostname (e.g. an
  actual utility's own domain), with a real adapter deployed on real
  infrastructure they control — not a laptop.
- The literal `http://localhost:8081/...` doors you've been POSTing to
  are *your own machine's* way of reaching *your own* copy of that
  adapter. In production, each participant's own adapter would be
  reachable at their own real, internet-routable address instead.
- Everything this guide already showed you is real and would stay
  exactly as real: the shared catalog/discover services, the DeDi
  registry, the schema documents, and the network-wide and per-trade
  policy files are already genuine, independent, internet-hosted
  services — they don't depend on your Docker containers at all, and
  would keep working identically whether your own two participants are
  running or not. Stopping your Docker stack only removes *your own two
  test participants* from the picture — it doesn't touch anything else
  in this chain, because none of it actually lives inside your
  containers to begin with.

---

## Part 9 — Troubleshooting

**"Could not send request" / connection refused** — the containers
aren't up yet. Run `docker compose ps` and wait for everything to show
`Up`.

**A `404` instead of an ACK** — double-check the exact URL, especially
the trailing path (`catalog/publish` has two segments; everything else
is one). Copy it fresh from the collection.

**A `400`/NACK you didn't expect** — per Part 8.6 and 8.7, this means
either the network-wide policy or the per-trade policy genuinely found a
real violation in your message. Read the `error.message` field — it
names the exact rule, in plain English, every time. If you've edited a
request body by hand, this is the most likely reason: a currency, unit,
or discom value that doesn't match what one of those two real policy
files requires.

**You want to run through the whole demo again as a brand-new trade** —
edit the `transaction_id` collection variable (each collection's
**Variables** tab) to a new random value first.

**Done for the day** — `docker compose down` from the `install/` folder
stops everything cleanly.
