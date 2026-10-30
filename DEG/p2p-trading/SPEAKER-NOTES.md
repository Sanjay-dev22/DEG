# Speaker Notes — Grid Pulse Live Walkthrough

**Link:** https://claude.ai/code/artifact/9f163f9a-6dfd-478d-88ee-f6d5d9c92c97

This is written so you can read it almost verbatim tomorrow. Part 0 is the
mental model — **read this fully before the meeting**, even though you won't
say most of it word-for-word live. It answers the exact questions you asked
me (From/To/Path/Action, is this Postman, what does on_confirm actually do).
Once Part 0 is solid in your head, Parts 2–7 are click-by-click, hop-by-hop,
in order, from opening the link to the end.

Default view = 2D. Stay in 2D for the whole walkthrough — it's the clearer
one for a room. Only mention 3D mode exists at the very end, as a bonus.

---

## PART 0 — Read this first: the mental model

### 0.1 What this actually is

This page is not a generic diagram. Every node is a real container we
actually ran last night. Every arrow is a real HTTP call. Every payload
shown is either a real captured message from that run, or the exact fixture
file the devkit itself uses. Nothing here is invented for the demo.

### 0.2 The two sides, and the one bridge

Look at the diagram (don't click anything yet):

- **Left side** = everything belonging to **BuyerApp** — the buying
  prosumer's platform, on **BRPL** (a Delhi electricity company).
- **Right side** = everything belonging to **SellerApp** — the selling
  prosumer's platform, on **TPDDL** (a different Delhi electricity company).
- **Center** = `beckn-router`, the *only* thing that touches both sides.
  Think of it as the building's shared reception desk — messages from the
  left side go through it to reach the right side, and back.
- **Top-center** = the shared **Catalog / Discovery** service, where
  offers get listed and searched.
- **Bottom** = the ledger machinery for each side, and the real external
  ledger service.

Each "side" (BuyerApp's stack, SellerApp's stack) has two layers:

1. **The sandbox** (`BuyerApp`, `SellerApp`) — this is the **business app**.
   Think of it as the actual trading platform's own software — the part
   that decides *what* to do ("I want to buy this offer").
2. **The onix adapter** (`onix-buyerapp`, `onix-sellerapp`) — this is the
   **protocol engine**. It's a separate running service whose only job is
   to sign, verify, check policy, and route messages correctly, so the
   business app above it never has to worry about cryptography or the
   network — it just hands off a message and trusts the adapter to deliver
   it safely.

**Say this out loud once, early:** *"The business logic and the network
plumbing are two separate pieces of software, running as two separate
containers. That split is deliberate — it's how real Beckn deployments are
built."*

### 0.3 What "From / To / Path / Action" actually mean

This was your main confusion — here's the direct answer.

Every hop in this demo represents **one real network delivery** — like a
courier carrying one envelope from one building to the next.

| Field | What it means | Analogy |
|---|---|---|
| **From** | Which component is sending this particular leg | Which building the courier leaves from |
| **To** | Which component receives this particular leg | Which building the courier arrives at |
| **Path** | The exact web address on the *receiving* side that this hits | The exact door / mailbox at that building |
| **Action** | The Beckn "verb" written inside the message — what kind of message this is (`discover`, `confirm`, `on_confirm`, etc.) | What's written on the envelope's label |

**Is this Postman?** Yes, literally. Whenever a hop shows a real `Path` (like
`/bap/caller/`) **and** a real payload, that combination — `http://<host>:<port><path>`,
POST, this exact JSON as the body — is precisely what you'd type into
Postman to replicate it by hand. In fact, the real devkit we ran last night
ships Postman collections that do exactly this. What you're watching on
screen *is* a Postman-style API call, just drawn as a moving light instead
of a request tab.

**When Path is blank** (you'll see the handler say `→ business logic`) —
that's *not* a network call. That's the onix adapter, having already
verified the message is trustworthy, handing it internally to the business
app sitting right next to it — same machine, same company, no network hop.
Like a mailroom clerk walking a verified letter down the hall, instead of
putting it back on a truck.

### 0.4 The single most important thing to get right: ACK now, answer later

You asked directly: *"about this on_confirm, so do I send it back or how?"*
This is the crux of Beckn, so get this analogy solid:

> Think of ordering food on a delivery app. You tap **Confirm Order**. You
> instantly see **"Order placed ✓"**. That tick is *not* the restaurant
> saying yes — it's just the app confirming your tap was received. A few
> minutes later, the **restaurant** sends you a *separate* notification:
> "Your order has been accepted." That's a brand new message, pushed to
> you, not a delayed reply to your original tap.

Beckn works exactly like this, for real:

1. BuyerApp sends `confirm`. SellerApp's adapter checks it and replies
   **synchronously, instantly** with a tiny `{"status":"ACK"}` — that's
   just "message received," nothing more.
2. Separately — could be seconds or minutes later — **SellerApp's own
   adapter starts a brand-new outbound call**, this time carrying
   `on_confirm`, addressed back to BuyerApp's receiving address.
3. BuyerApp's adapter receives *that*, sends *its own* ACK back, and
   *then* hands the real content to BuyerApp's business logic.

So: **`confirm` and `on_confirm` are two separate HTTP calls, going in
opposite directions, at different times** — not a request and its response
in the same round trip. Same pattern for `init`→`on_init` and
`status`→`on_status`. You'll watch this exact thing happen on screen in a
few minutes and it'll click immediately.

### 0.5 What the "processor steps" are

Every message, in or out, walks through a checklist inside the onix
adapter before it's allowed to proceed — like an airport security line with
several booths. Not every booth does something for every traveler:

- **`validateSign`** — checks the sender's digital signature is real (their ID is genuine)
- **`checkPolicy`** — a network-wide security scan every message goes through, no exceptions
- **`addRoute`** — looks up which actual address to send this to next (which gate to go to)
- **`validateSchema`** — checks the message is filled out in the correct format (boarding pass filled correctly)
- **`contractpolicyenforcer`** — checks the message against *this specific seller's own business rules* — **this is the only booth that can turn a message away**
- **`sign`** — stamps the outgoing message as officially from us
- **`degledgerrecorder`** — logs the trade into the relevant ledger's record book

On screen, a step with an **amber left border** actually did something
meaningful for that specific message. A **dimmed** step still ran, but had
nothing to do this time — like walking past a booth that only checks
something that doesn't apply to you.

### 0.6 What's inside every payload

Every JSON has exactly two parts:

- **`context`** — the outside of the envelope: which network, who's
  sending (`bapId`), who's receiving (`bppId`), a `transactionId` (ties
  every message of *this one trade* together, start to finish), a
  `messageId` (unique to just this one message), and a timestamp.
- **`message`** — the letter itself. For a trade, this is a `contract`
  object: its status, the `commitments` (what's being bought/sold, how
  much, at what price), `contractAttributes` (who the four roles are —
  buyer platform, seller platform, buyer's discom, seller's discom — and
  which policy document governs this trade), and later, once settled,
  the actual computed money split.

You now have everything you need. The rest of this document just walks the
real sequence, telling you exactly what to click and exactly what to say.

---

## PART 1 — Opening (before you click anything)

**Say:**

> "What I'm about to show is a live, clickable map of a real trade we ran
> on an actual Beckn network last night — not a mockup. Every box on this
> screen is a real piece of software that was actually running, every
> arrow is a real network call, and every number and every payload you'll
> see is either captured from that real run or is the exact file the
> system itself used.
>
> The scenario: a rooftop solar owner on one Delhi electricity company,
> TPDDL, sells power directly to a buyer on a *different* electricity
> company, BRPL — and the whole thing — discovery, negotiation, payment
> split — happens automatically over an open network, with each company's
> own rules still enforced.
>
> I'll click through this exactly as it happened: publish the offer,
> discover it, negotiate, confirm, settle — and then I'll show you what
> happens when the network *rejects* a trade, so you can see the
> enforcement is real too."

Open the link. Give it a second to load.

---

## PART 2 — Orientation tour (30–45 seconds, no flow selected yet)

Don't click a flow tab yet. Just point.

**Say, pointing at the screen as you go:**

> "Left side is BuyerApp's world, right side is SellerApp's world — you can
> see the dotted boxes labeling `bap_side` and `bpp_side`, which are the
> two separate private networks these actually ran on. The only thing that
> touches both sides is this center node, `beckn-router` — think of it as
> reception; every message between the two sides passes through it, and it
> does nothing else — no signing, no checking, pure delivery.
>
> Each side has two layers. The outer ring — BuyerApp, SellerApp — is the
> actual trading app, the business software. One layer in — `onix-buyerapp`,
> `onix-sellerapp` — is the protocol engine: a separate service whose only
> job is signing, verifying, and routing, so the business app never has to
> think about network security.
>
> Up top is the shared catalog and discovery service. Down here" *(point at
> the bottom nodes)* "are the two utilities' own ledger systems — TPDDL's
> and BRPL's — and right at the bottom, this one's a bit special" *(point
> at the teal node)* "— that's the *actual, real, hosted* ledger service on
> the internet, not something we ran ourselves. I'll show you proof it's
> real when we get there.
>
> These two grey dots" *(point at the dormant discom-actor nodes)* "are
> real parts of this system we're *not* using tonight — I've left them
> visible on purpose, labeled 'not used this walkthrough,' rather than
> hide them, so this is the honest full picture, not a cropped one."

Optional — click once on the `beckn-router` node itself to show the detail
panel works on nodes too, then move on:

> "You can click any node at rest, any time, and it'll tell you what it is."

**[CLICK: the `beckn-router` node]** — panel shows: *"THE ONLY BRIDGE /
beckn-router / A Caddy reverse proxy — the single container with a foot in
both docker networks. Routes purely by HTTP Host header... It does not
sign, verify, or inspect payloads — pure transport."*

> "That's it — a real reverse proxy, nothing clever, purely a delivery
> mechanism."

Now move to the flow picker at the top.

---

## PART 3 — FLOW 1: Publish

**[CLICK: "1 Publish" tab]**

**Say:**

> "First thing that has to happen, before any buyer can find anything: the
> seller lists their offer. This is a one-time setup step, not part of the
> per-trade conversation."

### Hop 1 of 2

**[CLICK: hop tick "1"]**

Panel shows:
```
CATALOG/PUBLISH — HOP 1 / 2
onix-sellerapp · bppTxnCaller    [200 · ACK]
This is the one-time catalog listing — not part of the per-trade round trip.

Address
From    SellerApp
To      beckn-router
Path    /bpp/caller/
Action  catalog/publish

Processor steps that ran
contractpolicyenforcer   publish self-check: is this offer within the seller's own policy limits?
validateSchema           Validates the payload's JSON structure against the official Beckn + DEG JSON-LD schemas.
checkPolicy              Evaluates the network-wide OPA policy — the same rules apply to every message on this network.
addRoute                 Looks up the recipient's real endpoint via the DeDi registry — resolves exactly where this message goes next.
sign                     Signs the outgoing message with this participant's own private key so the receiver can verify it.

Real payload at this hop
{ ...publishCatalog payload... }
```

**Say:**

> "SellerApp's business software decides to publish an offer, and hands it
> to its own onix adapter — that's the 'From: SellerApp' — which is about
> to send it out to `beckn-router` — that's the 'To'. The exact door it's
> knocking on is `/bpp/caller/` — that's a real URL path this adapter is
> listening on, port 8082 if you look at the diagram. And 'Action' —
> `catalog/publish` — is the label on this envelope, telling the network
> what kind of message this is.
>
> Before it's allowed to leave, it walks through five checkpoints. The
> first one, `contractpolicyenforcer`, is doing something specific here —
> checking the seller's *own* offer against the seller's *own* policy
> limits, a self-check before it even reaches the fabric. The rest —
> schema check, network policy check, look up where to send it, sign it —
> all run and all pass.
>
> And here's the actual payload that went out — real JSON. Up top,
> `context` — this is going out under `catalog/publish`, from
> `sellerapp.example.com`. Down in `message`, you can see the actual
> offer: two price bands — 12.5 rupees per kWh for the first slot, 14.5
> for the second, with quantities available in each. That's literally the
> offer sitting on the network right now."

### Hop 2 of 2

**[CLICK: hop tick "2"]**

Panel shows:
```
CATALOG/PUBLISH — HOP 2 / 2
beckn-router    [200 · ACK]
Caddy proxies by Host header — pure transport, no inspection.

Address
From    beckn-router
To      Catalog / Discovery
Path    → Catalog/Discovery
Action  catalog/publish
```
(No processor-steps section and no payload box here — point that out.)

**Say:**

> "Second hop — the router just forwards it on to the catalog service.
> Notice there's no processor-steps list and no payload box shown for
> this one — that's deliberate, not missing. The router doesn't run any
> checks and doesn't re-show the payload because it's not opening the
> envelope, just delivering it unchanged. The offer is now live on the
> network."

---

## PART 4 — FLOW 2: Discover

**[CLICK: "2 Discover" tab]**

**Say:**

> "Now the other side: BuyerApp, on BRPL, is looking for solar offers.
> This is the buyer independently searching — nobody pushed this offer to
> them."

### Hop 1 of 2

**[CLICK: hop tick "1"]**

Panel shows:
```
DISCOVER — HOP 1 / 2
onix-buyerapp · bapTxnCaller    [200 · ACK]

Address
From    BuyerApp
To      beckn-router
Path    /bap/caller/
Action  discover

Processor steps that ran
contractpolicyenforcer   not in this handler's enforced actions (select/init/confirm only) — passes through untouched
validateSchema           ...
checkPolicy              ...
addRoute                 ...
sign                     ...

Real payload at this hop
{ ...discover payload... }
```

**Say:**

> "Same shape as before, mirrored — BuyerApp's adapter, going out its
> `/bap/caller/` door this time, action `discover`. Worth calling out:
> `contractpolicyenforcer` is now *dimmed*, not highlighted — because this
> particular checkpoint only actually enforces anything on `select`,
> `init`, and `confirm`. A plain search doesn't need a business-rule check,
> so it just passes through untouched. That's what a dimmed step means
> everywhere in this demo — it ran, it just had nothing to do this time.
>
> The payload here is intentionally tiny — just a search filter, looking
> for anything tagged as an `EnergyTradeOffer` on the network. A discover
> call doesn't carry a contract yet, because there isn't one yet."

### Hop 2 of 2

**[CLICK: hop tick "2"]**

Panel shows router forwarding to Catalog/Discovery, note: *"The discover
call hits the shared catalog/discovery backend directly — outside this
devkit's own topology."*

**Say:**

> "Same router pass-through as before. And behind the scenes, the
> discovery service found the offer we just published and would hand it
> back to BuyerApp — that response isn't modeled as its own hop here
> because it comes from outside this devkit's own topology, but the
> practical result is: BuyerApp now sees SellerApp's offer."

---

## PART 5 — FLOW 3: Init

**[CLICK: "3 Init" tab]**

**Say:**

> "Now the two sides actually talk to each other directly for the first
> time. `init` is where identity gets exchanged — meter IDs, which discom
> each side belongs to — before anyone commits to anything. Eight real
> hops here, because this is the first round trip *and* its callback."

### Hop 1 of 8

**[CLICK: hop tick "1"]** — BuyerApp → onix-buyerapp, `/bap/caller/`, action `init`, ACK.
Steps: `contractpolicyenforcer` (hit, *"buyer-side self-check against the
policy already linked in the offer"*), then the same four familiar
checkpoints.

**Say:**

> "BuyerApp decides to init. Notice `contractpolicyenforcer` is
> highlighted again now — `init` *is* one of the actions it actually
> enforces. Right now it's just the buyer checking itself against the
> policy that was already attached to the offer — nothing to reject yet."

Payload: PAY.init — **explain fully, this is the richest payload so far:**

> "This is a much bigger payload than discover — it's a full contract
> draft. Status is `DRAFT`. Down in commitments, you'll see the two price
> intervals again — 12.5 and 14.5 rupees per kWh — but now with a new
> field, `REQUESTED_QTY`: 20.5 kWh and 15.5 kWh — that's the buyer stating
> how much of the offer they actually want. And down in
> `contractAttributes.roles`, you can see all four real roles named
> explicitly: `buyerPlatform` is BuyerApp, `sellerPlatform` is SellerApp,
> `buyerDiscom` is `TEST_DISCOM_BUYER`, `sellerDiscom` is
> `TEST_DISCOM_SELLER`. Those last two are the actual utilities — they're
> written into the contract's data even though, as we'll see, they never
> once speak Beckn directly themselves."

### Hop 2 of 8

**[CLICK: hop tick "2"]** — onix-buyerapp → router, `Host: sellerapp.example.com`, no steps/payload shown.

**Say:**

> "Pure delivery again. Notice the Path field this time isn't a URL suffix
> — it says `Host: sellerapp.example.com`. That's because this hop is the
> router itself deciding *where* to send it, by reading the Host header on
> the request — literally how it knows which side to forward to."

### Hop 3 of 8

**[CLICK: hop tick "3"]** — router → onix-sellerapp, `/bpp/receiver/`, action `init`, ACK.
Steps: `validateSign` (hit, *"verifies BuyerApp's Ed25519 signature via
its DeDi record"*), `checkPolicy`, `addRoute`, `validateSchema`,
`contractpolicyenforcer` (hit, *"fetches TEST_DISCOM_SELLER's own
published policy and checks TEST_DISCOM_BUYER against its allowlist —
PASSES here"*), `degledgerrecorder` (dimmed, *"init isn't in this
handler's actions (status only)"*).
Note: *"This is the exact enforcement point — same step that rejects the
blocked-discom flow."*

**Say — this is an important one, slow down here:**

> "This is the moment the message actually arrives on SellerApp's side, at
> its receiving door, `/bpp/receiver/`. First thing that happens:
> `validateSign` — it checks BuyerApp's real digital signature against
> BuyerApp's public key, which it looks up from a real registry called
> DeDi. If that signature didn't match, this would stop right here.
>
> Then the important one: `contractpolicyenforcer` fetches *SellerApp's*
> own published policy — a real rule document — and checks whether
> `TEST_DISCOM_BUYER` is on the list of discoms SellerApp's policy allows
> trading with. Right now, it passes. Remember this exact checkpoint —
> we're coming back to this exact step later, when I show you it *reject*
> a trade instead."

### Hop 4 of 8

**[CLICK: hop tick "4"]** — onix-sellerapp → SellerApp, `→ business logic`, blank path, ACK.
Note: *"Synchronous 200 ACK. on_init follows asynchronously."*

**Say:**

> "This is that internal handoff I mentioned — no network call, the
> adapter just passes the now-verified message to SellerApp's own business
> software. And here's the ACK-now-answer-later pattern happening for
> real: this ACK is just 'got it.' SellerApp hasn't actually decided
> anything yet — that comes next, as a separate message."

### Hop 5 of 8

**[CLICK: hop tick "5"]** — SellerApp → onix-sellerapp, `/bpp/caller/`, action `on_init`, async.

**Say:**

> "And here's `on_init` — a brand new outbound call, initiated by
> SellerApp, going the *opposite* direction of the original `init`. This
> is exactly the pattern from Part 0 — not a reply to the same call, a
> fresh one."

Payload: PAY.onInit — brief:

> "Smaller payload — just confirming the contract is still `DRAFT`,
> acknowledging the commitment exists. Real negotiation content shows up
> later."

### Hop 6 of 8

**[CLICK: hop tick "6"]** — onix-sellerapp → router, `Host: buyerapp.example.com`, async.

> "Router forwarding on_init back toward BuyerApp — notice the Host is
> now buyerapp.example.com, the opposite direction from hop 2."

### Hop 7 of 8

**[CLICK: hop tick "7"]** — router → onix-buyerapp, `/bap/receiver/`, action `on_init`, async.
Same checkpoint chain (validateSign, checkPolicy, addRoute, validateSchema,
contractpolicyenforcer dimmed, degledgerrecorder dimmed).

> "Arrives at BuyerApp's own receiving door this time — `/bap/receiver/`.
> Verified the same way, but the two dimmed checks here don't apply to
> `on_init`."

### Hop 8 of 8

**[CLICK: hop tick "8"]** — onix-buyerapp → BuyerApp, internal handoff.

> "And it lands back at BuyerApp's own business software. Both sides now
> know each other's identity. Next: actually confirming the trade."

---

## PART 6 — FLOW 4: Confirm

**[CLICK: "4 Confirm" tab]**

**Say:**

> "This is the biggest one — eleven hops — because this is where the trade
> actually gets confirmed *and* where the ledger recording fires for the
> first time. Same request/callback shape as init, just with extra
> branches for the ledgers."

### Hop 1 of 11

**[CLICK: hop tick "1"]** — BuyerApp → onix-buyerapp, `/bap/caller/`, `confirm`, ACK. `contractpolicyenforcer` hit (*"buyer-side self-check, enforced"*).

Payload: PAY.confirm — **explain the new field:**

> "This one's trimmed down to just what's changing — still `DRAFT` status,
> same contract ID as before, but a `settlements` array has now appeared:
> `settlement-p2p-001`, status `PENDING`, with a real payee already
> attached — 'Seller Platform Pvt Ltd,' HDFC Bank. The *machinery* for
> paying the seller is wired into the message from this point on, even
> though nothing's actually been paid yet."

### Hop 2 of 11

**[CLICK: hop tick "2"]** — onix-buyerapp → router. Pure transport, as before.

### Hop 3 of 11

**[CLICK: hop tick "3"]** — router → onix-sellerapp, `/bpp/receiver/`, `confirm`, ACK.
`contractpolicyenforcer` hit again (*"enforced again — the discom allowlist check runs on every trade-forming action"*).

**Say:**

> "Same policy checkpoint as before, running again — worth noting out
> loud: this isn't checked once and forgotten, it's re-checked on *every*
> trade-forming step. select, init, confirm — all three get the same
> scrutiny."

### Hop 4 of 11

**[CLICK: hop tick "4"]** — onix-sellerapp → SellerApp, internal handoff.
Note: *"Both platforms now log the trade to their own discom ledger,
off-band."*

> "SellerApp's business logic now has the confirmed trade. And this note
> is foreshadowing what's about to happen — the ledger recording."

### Hop 5 of 11 — the ledger cascade begins

**[CLICK: hop tick "5"]** — SellerApp → onix-sellerapp, `/bpp/caller/`, `on_confirm`, async.
`degledgerrecorder` hit (*"on_confirm IS in this handler's actions — fires
the ledger cascade, live"*).
Note: *"degledgerrecorder now forwards a copy to seller-discom-ledger AND
directly to the external IES ledger."*

**Say — slow down, this is a genuinely important moment:**

> "SellerApp sends `on_confirm` — the real confirmation, going back the
> other way, same pattern as `on_init`. But look at the processor steps —
> `degledgerrecorder` is highlighted now, and it wasn't for `on_init`. This
> one specific plugin only fires on `on_confirm` and `on_status` — and
> when it fires, it doesn't just forward the message onward, it *also*
> makes copies and sends them to the ledger systems. That's what the next
> two hops are — real side-effects of this single step."

Payload: PAY.onConfirm — **explain:**

> "Contract status has flipped to `ACTIVE`. And down in `participants`,
> you can see `TEST_DISCOM_SELLER`'s own ledger address written right into
> the payload — `seller-discom-ledger.example.com` — that's literally how
> the system knows *where* to send the copy in the next hop."

### Hop 6 of 11 — cascade to seller's discom

**[CLICK: hop tick "6"]** — onix-sellerapp → onix-ledger-sellerdiscom, via beckn-router.
Note: *"Real, local cascade — recorded at TPDDL's own ledger TSP."*

**Say:**

> "This is a real, separate delivery — same on_confirm content, sent to
> TPDDL's own regulated ledger system. Same underlying network, same
> router. TPDDL now has its own record of this trade."

### Hop 7 of 11 — cascade to the real external ledger

**[CLICK: hop tick "7"]** — onix-sellerapp → IES Energy Ledger, direct, over the real internet.
Note: *"This is the hop we independently re-verified afterward — the
trade really landed here."*

**Say — this is your credibility moment, use it:**

> "And this one goes *straight out to the real internet* — not through our
> local router at all, directly to a real, independently hosted ledger
> service. This isn't simulated. After we ran this last night, we
> separately queried that ledger service — using completely different
> login credentials than the ones that wrote this record — and confirmed
> our trade was genuinely sitting there. I can show that proof if anyone
> wants to see it after this."

### Hop 8 of 11

**[CLICK: hop tick "8"]** — onix-sellerapp → router, heading back to buyerapp.example.com.

> "Meanwhile, the main on_confirm continues its own journey back to
> BuyerApp — the ledger cascade didn't interrupt it."

### Hop 9 of 11

**[CLICK: hop tick "9"]** — router → onix-buyerapp, `/bap/receiver/`, async.
`degledgerrecorder` hit again (*"on_confirm is in this handler's actions
too — cascades to the buyer's own discom"*).

**Say:**

> "Arrives at BuyerApp's side, and the same ledger-recording plugin fires
> here too — because BuyerApp needs to record this trade with *its own*
> discom, BRPL, independently of what SellerApp just did with TPDDL."

### Hop 10 of 11 — cascade to buyer's discom

**[CLICK: hop tick "10"]** — onix-buyerapp → onix-ledger-buyerdiscom, via router.
Note: *"Real, local cascade — recorded at BRPL's own ledger TSP."*

> "Mirror of hop 6, on the buyer's side — BRPL now has its own record too.
> Notice: two separate utilities, two separate ledger writes, neither one
> waiting on the other."

### Hop 11 of 11

**[CLICK: hop tick "11"]** — onix-buyerapp → BuyerApp, internal handoff.

> "And it lands at BuyerApp's business software. The trade is now
> `ACTIVE` on both sides, and both discoms have their own record of it.
> Next: what happens after the power's actually delivered."

---

## PART 7 — FLOW 5: Settle

**[CLICK: "5 Settle" tab]**

**Say:**

> "This is the payoff. After delivery happens, the seller reports what was
> actually delivered — and the system computes, automatically, exactly who
> owes what."

### Hop 1 of 5

**[CLICK: hop tick "1"]** — SellerApp → onix-sellerapp, `/bpp/caller/`, `on_status`, async.
`contractpolicyenforcer` hit (*"on_status IS enforced here — this is the
exact step that computes revenueFlows"*).
Note: *"18.5 kWh × ₹12.5 + 14.2 kWh × ₹14.5 = ₹437.15 to the seller,
computed here — not typed anywhere."*

**Say — the single most important sentence of the whole demo:**

> "This one step, right here, `contractpolicyenforcer`, is where the
> settlement math actually happens. Nobody typed 437.15 rupees into
> anything — this checkpoint fetched the seller's own published pricing
> policy and computed it live, from the delivered quantities."

Payload: PAY.onStatusSettled — **explain fully:**

> "Status is now `COMPLETE`. Down in commitments, `FINAL_ALLOC` — 18.5 kWh
> for the first interval, 14.2 for the second — that's the *actual*
> delivered amount, slightly different from what was requested, because
> real delivery rarely matches the request exactly. And here's the payoff
> — down in `consideration.revenueFlows`: `sellerPlatform` gets **plus
> 437.15 rupees**, `buyerPlatform` gets **minus 437.15** — the two numbers
> sum to exactly zero. And right below that, `settlements` shows a real
> `PaymentAction` — status `SETTLED`, with an actual transaction
> reference. This is the full lifecycle, start to money, in one payload."

### Hop 2 of 5

**[CLICK: hop tick "2"]** — onix-sellerapp → router, heading to buyerapp.example.com.

### Hop 3 of 5

**[CLICK: hop tick "3"]** — router → onix-buyerapp, `/bap/receiver/`, async.
`contractpolicyenforcer` hit (*"injection-only on this side — the
already-computed flows pass through"*), `degledgerrecorder` hit (*"on_status
is enforced here — cascades the final settlement to buyerDiscom"*).

**Say:**

> "On BuyerApp's side, the policy step runs again, but this time it's
> not *computing* anything new — the numbers were already worked out on
> the seller's side and are just passing through. And the ledger recorder
> fires one more time, to push the final settled numbers to BuyerApp's own
> discom."

### Hop 4 of 5

**[CLICK: hop tick "4"]** — onix-buyerapp → onix-ledger-buyerdiscom, via router.

> "Final ledger write — BRPL now has the fully settled record, with the
> real delivered quantities and the real amount owed."

### Hop 5 of 5

**[CLICK: hop tick "5"]** — onix-buyerapp → BuyerApp, internal handoff.

**Say:**

> "And that's the complete, real lifecycle — publish, discover, negotiate,
> confirm, settle. Every number you saw was computed by the network, not
> typed by a person. Now let me show you the other side of trust — what
> happens when the network says no."

---

## PART 8 — FLOW 6: Rejected

**[CLICK: "6 Rejected" tab]** — notice the tab itself turns red.

**Say:**

> "Same exact flow, `init`, but this time I'm going to try to trade with a
> discom that isn't on the seller's approved list — watch exactly which
> checkpoint catches it."

### Hop 1 of 3

**[CLICK: hop tick "1"]** — BuyerApp → onix-buyerapp, `/bap/caller/`, `init`, ACK.
`contractpolicyenforcer` hit (*"buyer-side self-check passes — the buyer
doesn't know the seller-discom's specific allowlist yet"*).

**Say:**

> "This leaves BuyerApp's side just fine — the buyer's own self-check
> passes, because the buyer has no way of knowing *SellerApp's* private
> allowlist. This message looks completely normal so far."

Payload: PAY.initBlocked — quick callout:

> "Same shape as the real init payload, one field different —
> `buyerDiscom` is now `TEST_OUTSIDE_DISCOM` instead of the approved
> `TEST_DISCOM_BUYER`."

### Hop 2 of 3

**[CLICK: hop tick "2"]** — router forwarding, as normal.

### Hop 3 of 3 — the rejection

**[CLICK: hop tick "3"]** — router → onix-sellerapp, `/bpp/receiver/`, `init`.
Badge now reads **`400 · NACK`** in red.
`contractpolicyenforcer` hit (*"fetches TEST_DISCOM_SELLER's policy —
TEST_OUTSIDE_DISCOM is NOT in allowed_buyer_discoms → violation → 400 NACK,
synchronously"*).
Note: *"The contract never forms. sandbox-sellerapp's business logic is
never even reached."*

**Say — this is your closing proof point, take your time:**

> "Same exact checkpoint as before — `contractpolicyenforcer`, the same
> one that let the real trade through — but this time it fetches
> SellerApp's real policy, checks the allowlist, and this discom isn't on
> it. Look at the badge: 400, NACK, not ACK. And notice this is
> *synchronous* — SellerApp doesn't need to send anything back later, this
> is rejected on the spot, in the very same call."

Point at the payload box — the real NACK response:

> "And here's the actual response text the network sent back, word for
> word: *'buyer discom TEST_OUTSIDE_DISCOM is not allowed to trade with
> this discom's prosumers on the test network'* — and it even lists the
> exact allowed discoms: BRPL, PaVVNL, and the two test ones we used
> tonight. SellerApp's own business software never even sees this attempt
> — it's stopped one layer before, at the adapter. The contract never
> forms, nobody's on the hook for anything."

---

## PART 9 — Closing

**Say:**

> "So that's the complete real lifecycle: an offer gets published, a buyer
> discovers it, both sides exchange identity, confirm the trade, and after
> delivery the network computes the exact payment split automatically —
> and separately, we proved the network actually enforces its own rules
> when a trade shouldn't happen. Every hop you watched was a real signed
> HTTP call between real running software, and the two ledger writes you
> saw are sitting in a real, independently verifiable hosted service right
> now."

**Optional bonus, only if there's time and appetite:**

> "One more thing — this whole map also works in full 3D, if anyone wants
> to physically fly around the network afterward." **[point at "Enter 3D
> mode," don't click it live unless asked]** "Same data, same clicking,
> just a different way to explore it — I'd suggest looking at that after,
> one-on-one, rather than spending room time on it now."

Also mention if useful: there's a **global Play button** with a speed
slider at the bottom — if someone wants to just *watch* the whole thing
run start-to-finish without you clicking each hop, that's what it's for.
You don't need to demo this live; just know it exists in case someone
asks "can it just play by itself?"

---

## Quick-reference: likely questions

**"Is this actually running right now, live?"**
No — this is a recorded, real capture of an actual run from last night,
made interactive so we can walk through it at our own pace. The Docker
stack it came from is still up on my machine if anyone wants to see it run
live separately.

**"What's the difference between the onix boxes and the app boxes?"**
The app (BuyerApp/SellerApp) is the actual trading platform's business
software. Onix is the shared, reusable protocol engine every Beckn
participant runs in front of their app — it's not something we wrote
custom, it's the standard adapter.

**"Why does the payload look the same across several hops?"**
Because it genuinely is the same message, just being carried further along
its journey — signatures and routing wrap around it, but the actual
content (the contract) doesn't change until a new action happens.

**"Could a bad actor fake being SellerApp?"**
No — every message is signed with a private key only the real participant
holds, and `validateSign` checks that signature against a public key
published in a real registry (DeDi) before anything else is even
processed.

**"What's DeDi?"**
The real, public directory that this whole network uses to look up who's
allowed to be on the network and what their public signing key is — like a
phone book, but cryptographically verifiable.
