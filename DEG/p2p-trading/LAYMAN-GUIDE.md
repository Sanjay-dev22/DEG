# The Plain-English Guide to Grid Pulse

**For anyone in the room who has never heard the words "Beckn," "BAP," "BPP," "discom," or "IES" before tonight.**

This document assumes nothing. If you read this once, start to finish, you
will understand everything Grid Pulse shows on screen — every box, every
moving light, every number — without needing to know anything about
software, networking, or the electricity industry going in.

It's written to be read **before** the demo, and kept open **during** it as
a reference. It does not tell you what to click or say — that's a separate
document for the presenter. This one is purely: *what does all of this
actually mean.*

---

## Part 1 — The whole story, in one paragraph

Imagine you have solar panels on your roof and some mornings you generate
more electricity than you use. Normally, the only place you can sell that
extra power back to is your own electricity company. This demo shows
something new: a person with solar panels on **one** electricity company's
grid selling their spare power **directly** to a stranger on a **different**
electricity company's grid — automatically, over the internet, with both
companies' own rules still fully respected, and the payment split computed
by the system itself, not typed in by a person. Grid Pulse is a real
recording of exactly that happening, made clickable so we can walk through
it at our own pace instead of watching it fly by in a terminal window.

Everything you'll see tonight — every box, every line, every payload — is
real. Nothing was invented for the slide deck. It's a screenshot of an
actual computer conversation that actually happened.

---

## Part 2 — The problem, before the jargon

Today, if you have solar panels, selling your extra electricity is usually
a one-way relationship with your own electricity provider, on their terms.
There's no easy, trusted way for two ordinary people — on two *different*
electricity providers — to just... trade directly with each other the way
you'd buy something from a stranger on an online marketplace.

The reason it's hard isn't the electricity — power already flows through
shared wires. The hard part is **trust and paperwork**: how does a buyer
on Company A know a seller on Company B is legitimate? How does the trade
get recorded so both companies still know what happened on their own grid,
for billing and regulation? How does money change hands correctly?

Tonight's demo is one real, working answer to that: a shared set of rules
that any electricity company's software can plug into, so trades like this
can happen safely and automatically, between total strangers, across
company lines.

---

## Part 3 — The cast of characters

Read this section slowly — once these names make sense, the rest of the
demo is easy. Every name below is something you will actually see written
on screen tonight.

### The people

**Prosumer** — an ordinary person who both *consumes* electricity and
*produces* some of their own (rooftop solar). Tonight there are two: one
selling their extra solar power, one buying it.

### The companies

**Discom** — short for **Dis**tribution **Com**pany. This is the real-world
business that owns the physical wires to your building and sends you your
electricity bill. Tonight's demo uses two real, different discoms that
operate in different parts of Delhi:

- **TPDDL** — the seller's electricity company.
- **BRPL** — the buyer's electricity company.

The entire point of the demo is that these are **two separate companies**
who don't automatically trust each other's customers — and the trade still
goes through safely.

### The shared rulebook

**Beckn** — not a company, not an app. Beckn is an open, shared *rulebook*
— a way of formatting messages — that lets independent computer systems,
built by completely different organizations, talk to each other reliably,
without anyone having to build a custom one-off connection between every
pair of companies. Think of it like a universal shipping-label standard:
any courier company can read any other courier's label, because they all
agreed on the same format, even though they're all separate businesses.
Beckn already powers things like open food-delivery and open shopping
networks in India — this is that same idea, applied to electricity.

**DEG (Digital Energy Grid)** — Beckn's rulebook, specifically written for
buying and selling energy. It defines exactly what an electricity "offer,"
"order," and "contract" have to look like so any two energy companies'
systems can understand each other.

**IES (India Energy Stack)** — the actual, real, live network running on
the internet tonight, where these DEG rules are being used for real. It's
the specific "network" this whole trade happened on (you'll even see its
web address, `indiaenergystack.in`, sitting inside the real messages).

### The two sides of tonight's trade

Every box on the left half of the screen belongs to the buyer's side.
Every box on the right half belongs to the seller's side. Each side is
built the same way, in two layers:

**BuyerApp / SellerApp** — the actual trading platform each person uses —
this is the "app" itself, the software that makes the business decision
("I want to buy this," "I want to sell this"). Think of it like two
different food-delivery apps: they look and work differently, but because
they both follow the same shared rulebook (Beckn), they can still talk to
each other.

**The onix adapter** (`onix-buyerapp`, `onix-sellerapp`) — a separate piece
of software sitting directly in front of each app, whose *only* job is
security and translation: checking who a message really came from, making
sure it's filled in correctly, checking it against the company's own
trading rules, and sending it to the right address. Think of this as a
dedicated **security guard and mailroom clerk** standing at each company's
front door. Because this guard exists, the app behind it never has to
worry about any of that — it just hands a message to its own guard and
trusts it'll be handled safely.

*(On screen these guards are drawn as blue circles, sitting just below the
amber "app" circles — one guard per side.)*

### The one thing that touches both sides

**beckn-router** — sits in the exact middle of the screen. This is nothing
more than a **reception desk / mailroom**: every message crossing between
the buyer's side and the seller's side physically has to pass through this
one box. It doesn't read the message, doesn't check anything, doesn't make
any decisions — it just looks at the address on the envelope and forwards
it to the correct side. It's the one and only bridge between two otherwise
completely separate, private computer networks.

### The shared noticeboard

**Catalog / Discovery** — think of this as a shared, public noticeboard or
marketplace listing page. Sellers pin their offers up here; buyers come
here to search. It's shared network infrastructure, not owned by either
side.

### The small stuff you can basically ignore

**redis** (a small grey box on each side) — just a scratchpad each guard
keeps for itself, jotting down "I've already seen this exact message" so
it doesn't get processed twice. It never talks to the other side and has
no role in the actual story.

### The paper trail

Every trade eventually has to be written down somewhere official, on
*each* company's own books — because each discom is independently
regulated and needs its own record.

**Discom ledger** (`SellerDiscom Ledger`, `BuyerDiscom Ledger`) — each
company's own official notebook of record for trades like this. TPDDL
keeps its own; BRPL keeps its own. Neither company relies on the other's
notebook — each writes down its own copy, independently. In front of each
notebook sits its own security guard (`onix-ledger-sellerdiscom`,
`onix-ledger-buyerdiscom`) — same guard-and-translator role as before, just
guarding a notebook instead of a trading app.

**IES Energy Ledger** — one more notebook, but a special one: this one is
**real and lives out on the actual public internet**, run by the wider
India Energy Stack network itself, completely independent of anything we
set up ourselves. Think of it as a **national receipts office**: a place
where trades from anywhere on the network get an independent copy filed,
so that, later, anyone could go check whether a trade genuinely happened —
without having to trust either company's own private books. We'll show you
proof this one is real, not a mockup.

### The two grey dots

You'll notice two dim, greyed-out circles on screen, labeled "not used this
walkthrough." These are real parts of the bigger system — the two
electricity companies' own separate meter-reading systems — that this
particular demo simply doesn't exercise tonight. They're left visible on
purpose, rather than hidden, so what you're looking at is the honest full
picture, not a cropped one.

---

## Part 4 — What's actually happening when you see a line light up

Every time a line lights up and a dot of light travels from one box to
another, that is **one real message being sent from one computer to
another** — nothing more mysterious than that. Think of it like a single
sealed, certified letter, physically carried from one building's front
door to another's.

When you click on a hop, a panel opens on the right with four fields.
Here's exactly what they mean:

| What you see | In plain English |
|---|---|
| **From** | Which box sent this particular letter |
| **To** | Which box received it |
| **Path** | The exact "door" it knocked on at the receiving box — a literal web address |
| **Action** | The label written on the envelope, saying what *kind* of message this is (an offer, a search, a confirmation, etc.) |

**Is this like a webpage loading, or more like a phone call?** It's neither
— it's closest to a **certified letter**. One side sends a message, the
other side has to say "got it," and separately, the content is acted on.
This is exactly how a tool called *Postman* works too — a tool developers
use to fire off one message and see what comes back. What you're watching
on screen is that same idea, drawn as a moving light instead of a form on a
screen.

Sometimes you'll see the "Path" field blank, saying only *"→ business
logic."* That means no letter left the building at all — it's just the
guard, having already checked the message is trustworthy, walking it down
the hall internally to the app sitting right next to it. No mailbox
involved, because it's the same company's own software talking to itself.

**Inside every real message you'll open, there are always two parts:**

- The **outside of the envelope** — which network this is on, who it's
  from, who it's to, a tracking number shared by every message in this one
  trade (so they can all be tied together later), and a timestamp.
- The **letter itself** — the actual content: what's being bought or sold,
  how much, at what price, and (later on) who the money is going to and
  from.

---

## Part 5 — The single most important idea: "got your message" vs. "here's my actual answer"

This is the one idea that makes the rest of the demo make sense, so take
your time with it.

Think about ordering food on a delivery app. You tap **Confirm Order**.
Instantly, you see **"Order placed ✓."** That tick mark is **not** the
restaurant saying yes — it's just the app confirming your tap was received.
A few minutes later, the *restaurant* sends a **separate, brand-new**
notification: "Your order has been accepted." That's a new message, pushed
to you — not a delayed reply to your original tap.

Tonight's network works exactly like that, for real:

1. The buyer sends a request. The seller's guard instantly replies "got
   it" — nothing more. That's just an instant receipt, not a decision.
2. Separately — moments later — the seller's own side starts a **brand
   new outbound message**, going the **opposite direction**, carrying the
   actual answer.
3. The buyer's side receives that, instantly sends its own "got it," and
   *then* hands the real answer to the buyer's own app.

So the "request" and its "real answer" are always **two separate letters,
travelling in opposite directions, sent at different moments** — never a
single round trip. You'll watch this exact pattern happen, more than once,
in a few minutes, and it will click immediately once you see it.

---

## Part 6 — The screen glossary: what those technical words on screen actually mean

When you click a hop, you'll sometimes see a short checklist of technical
step names. Every incoming or outgoing message walks through a short
checklist at its guard — like an airport security line with a few booths,
where not every booth has something to do for every traveller. Here is
every single one you might see, translated:

| What you'll see on screen | What it actually means, plainly |
|---|---|
| `validateSign` | *"Is this really who they claim to be?"* — checks a digital signature, like checking an ID card, against a real public directory of who's allowed on this network. |
| `checkPolicy` | A general security scan every single message on the network goes through, no matter who sent it or what it's about. |
| `addRoute` | Looks up the correct address to forward this message to next. |
| `validateSchema` | Checks the message is filled in correctly and completely — like a form checked for missing required fields. |
| `contractpolicyenforcer` | Checks *this specific trade* against *this specific company's own rules* about who it's willing to trade with. **This is the only checkpoint that can actually stop a trade** — think of it as the bouncer checking a guest list. |
| `sign` | Stamps the outgoing message as officially, verifiably from us — like a wax seal on the envelope. |
| `degledgerrecorder` | Sends a copy of the trade to the relevant record-keeping notebooks. |

On screen, a step with a bright/highlighted border actually did something
meaningful for that specific message. A dimmed step still ran — it just
had nothing to do this time, like walking past a security booth that only
checks something that doesn't apply to you.

---

## Part 7 — Walking through the actual demo

The demo has six tabs across the top. They run in this order, and this is
also the order the real events happened in, last night, for real.

### 1. Publish — the seller lists their offer

Before anyone can buy anything, the seller has to list it. This is a
one-time setup step — not part of the back-and-forth of an actual trade.

**What happens:** the seller's app hands its offer to its own guard, which
checks it, stamps it, and forwards it to the shared noticeboard.

**The real offer, in plain terms:** the seller is listing **30.5 kWh** of
rooftop solar power, split into two time slots: an early slot priced at
**₹12.5 per unit**, and a later slot priced at **₹14.5 per unit**. (A "kWh"
— kilowatt-hour — is just the standard unit your own electricity bill is
measured in.)

### 2. Discover — the buyer goes looking

Now the other side: the buyer is searching the shared noticeboard for
solar offers, completely independently — nobody pushed this offer to them,
they went looking for it themselves. This message is deliberately tiny — a
buyer searching doesn't need to describe a trade yet, because there isn't
one yet.

### 3. Init — the two sides introduce themselves

This is the first time the buyer's side and seller's side actually talk
**directly** to each other. "Init" is short for *initiate* — it's where
both sides exchange who they are (which company each belongs to) before
anyone commits to anything. This is the longest first-time exchange (8
letters back and forth), because it's the first real conversation *and*
its answer, following the "got it, now here's my real answer" pattern from
Part 5.

**What's in the message:** the buyer says exactly how much of the offer
they actually want — **20.5 kWh** from the first slot, **15.5 kWh** from
the second — and both companies' names are written into the message in
plain sight: the buyer's company and the seller's company, side by side.

**The one moment to watch for:** partway through, you'll see the seller's
guard check the buyer's company against a private list of companies the
seller is willing to trade with. Tonight, it passes. Remember this exact
checkpoint — later, we'll show you the same checkpoint **reject** a trade
instead.

### 4. Confirm — the trade actually gets locked in

This is the biggest step (11 letters), because it's also the moment both
companies' own official notebooks get their first entry.

**What's new here:** payment machinery appears in the message for the
first time — a real payee is named (the seller's own bank details) — even
though no money has moved yet. Then, as the seller's side sends back its
confirmation, its guard doesn't just forward the message onward — it *also*
makes copies and sends them, in parallel, to: (1) the seller's own
company's notebook, and (2) directly out to the real internet, to that
national receipts office (the IES Energy Ledger) mentioned in Part 3. Then
the same thing happens on the buyer's side, into their own company's
notebook. **Two separate companies, two separate notebook entries, neither
one waiting on the other.**

This is the credibility moment of the whole demo: that write to the real,
independent, internet-hosted ledger genuinely happened. It was checked
afterward, using completely different login credentials than the ones
that wrote it, and the trade really was sitting there.

### 5. Settle — the payoff: the system does the math itself

After the actual delivery of power happens, the seller reports exactly
what was really delivered, and the system computes, automatically, exactly
who owes what. Nobody types a number in anywhere — the checkpoint fetches
the seller's own published pricing and calculates it live, from the real
delivered amounts.

**The real numbers:** the actual amount delivered was **18.5 kWh** in the
first slot and **14.2 kWh** in the second (slightly different from what
was originally requested, because real-world delivery rarely matches a
request exactly). The math the system runs, live:

> 18.5 kWh × ₹12.5 + 14.2 kWh × ₹14.5 = **₹437.15**

The seller's side of the ledger shows **+₹437.15**. The buyer's side shows
**−₹437.15**. The two numbers cancel out exactly to zero — proof the money
is simply moving from one side to the other, correctly, with nothing lost
or invented in between.

### 6. Rejected — what happens when the network says no

Same exact "Init" conversation as before — except this time, the buyer
claims to belong to a company that isn't on the seller's approved list.

**What you'll see:** the message leaves the buyer's side completely
normally — the buyer's own side has no way of knowing the seller's private
list, so nothing looks wrong yet. But the moment it reaches the seller's
guard, the **exact same checkpoint** that let the real trade through this
time checks the list — and this company isn't on it. The badge on screen
flips from the usual "got it" (ACK) to a red **"rejected" (NACK)**, and
critically, this happens **instantly, in the same message** — the seller
doesn't need to send a separate reply later, the way it would for a normal
"got it, real answer coming" exchange. The contract never forms. The
seller's own trading app never even sees the attempt — it's stopped one
layer earlier, at the guard.

The actual rejection message, word for word, even names which companies
*are* allowed to trade with this seller — proving this is a real,
enforced rule, not a made-up demo failure.

---

## Part 8 — What this actually proves

By the end of the walkthrough, here's the plain-English version of what
you will have watched happen, for real:

- A person on **one** electricity company's network sold power directly
  to a stranger on a **completely different** electricity company's
  network — something today's normal setup doesn't let you do.
- Every step of that — listing the offer, finding it, agreeing on it,
  confirming it — happened **automatically**, over open messages any
  company's software can send and understand, with no custom one-off
  connection built between these two specific companies.
- Both companies still got **their own, independent, official record** of
  the trade — nobody had to trust the other company's bookkeeping.
- The final payment amount was **computed by the system itself**, from the
  real delivered numbers, and the two sides' numbers **provably cancel out
  to zero** — nothing invented, nothing lost.
- The system can and does **refuse** a trade on the spot when a company's
  own rules say it should, proving the trust isn't just assumed — it's
  actively enforced, automatically, every single time.
- One of the record-keeping writes you watched happen landed on a **real,
  independent, internet-hosted service** — not something we made up for
  tonight, and independently verifiable after the fact.

---

## Part 9 — Likely questions, answered plainly

**"Is this actually happening live, right now, on screen?"**
No — this is an interactive, clickable *recording* of a real run that
genuinely happened, made so we can walk through it at our own pace instead
of watching it fly by in a terminal window.

**"Could someone fake being the seller or the buyer?"**
No — every message carries a digital signature that only the real
company holds the private "key" to create, and it's checked against a
real public directory before anything else even happens.

**"Why do the two companies need separate notebooks at all — why not one shared one?"**
Because each electricity company is independently regulated and legally
responsible for its own side of the trade — each needs its own
self-controlled, trustworthy record, rather than relying on someone else's
bookkeeping.

**"What would it take for this to work with real money and real meters?"**
Everything you saw tonight — the messages, the checks, the rejection, the
ledger writes — is the actual real mechanism, not a simplified stand-in.
The two components not exercised tonight (the greyed-out dots) are the
piece that would connect this to each company's real, physical smart
meters.

---

## One-page cheat sheet (keep this open during Q&A)

| Term | Plain meaning |
|---|---|
| Prosumer | A person who both uses and generates their own electricity |
| Discom | The real company that owns the power lines and bills you |
| BRPL / TPDDL | Two real, separate electricity companies in Delhi |
| Beckn | A shared rulebook letting different companies' software talk to each other |
| DEG (Digital Energy Grid) | Beckn's rulebook, specifically for buying/selling energy |
| IES (India Energy Stack) | The real, live network this trade actually ran on |
| BuyerApp / SellerApp | Each side's own trading software — the "app" itself |
| onix adapter | The security guard + mailroom clerk in front of each app |
| beckn-router | The one shared reception desk between the two sides |
| Catalog / Discovery | The shared public noticeboard where offers get listed and found |
| redis | A scratchpad each guard keeps — safe to ignore |
| Discom ledger | Each company's own official notebook recording the trade |
| IES Energy Ledger | The real, independent, internet-hosted national receipts office |
| "Hop" | One single message sent from one computer to another |
| ACK | "Got your message" — not yet a real answer |
| on_init / on_confirm / on_status | The *actual* answer, sent back separately, moments later |
| NACK | "Rejected" — the network refusing a message on the spot |

---

## Part 10 — Every single hop, explained in plain English

This is the section to lean on hardest. Every tab (1 through 6) is a
sequence of numbered "hops." Click any hop number and a panel opens on the
right with the same handful of sections every time: a badge, an **Address**
block (From / To / Path / Action), sometimes a **Processor steps that
ran** checklist, and sometimes a **Real payload at this hop** box. Below,
every single hop in the whole demo — in order, exactly as you'll click
through them — is translated into plain English: what it says, and what it
actually means.

A few things that are true on *every* hop, so they're not repeated 31
times below:

- A green badge reading **200 · ACK** means "message received, all good."
  A teal badge reading **async** means "this is one of those separate,
  send-it-back-later messages from Part 5." A red badge reading
  **400 · NACK** means "rejected, on the spot."
- When the **Path** field is blank and the panel just says *"→ business
  logic,"* nothing left the building — it's the guard handing an already
  verified message to its own app next door, no network trip involved.
- When there's no **Processor steps** section at all, that hop is
  `beckn-router` doing pure delivery — it doesn't check anything, so
  there's nothing to list.
- Only the checkpoints that actually had something to do ("hit," shown
  with a bright border on screen) are called out by name below. Any
  checkpoint not mentioned for a given hop either isn't shown for that hop,
  or ran but genuinely had nothing to do this time (dimmed on screen) — see
  Part 6 if you want the plain meaning of any checkpoint name again.

---

### Tab 1 — Publish (2 hops)

**Hop 1 of 2 — SellerApp → beckn-router**
*Badge: 200 · ACK.*
The seller's own app hands its offer to its own guard, which is about to
send it out the seller's front door (labelled `/bpp/caller/` on screen) to
the shared reception desk. The label on this envelope reads
`catalog/publish`.
Checks that mattered: a self-check that this offer fits within the
seller's own limits; the form is filled in correctly; it passes the
general network security scan; the correct next address is looked up; the
message is sealed as officially from the seller.
**What's inside:** the real offer — 30.5 units of rooftop solar, split
into two time slots: 12.5 rupees per unit for one, 14.5 for the other.
**Bottom line:** this is the seller putting their offer on the shelf, for
the very first time.

**Hop 2 of 2 — beckn-router → Catalog/Discovery**
*Badge: 200 · ACK.*
No checklist and no payload box on this one — on purpose. The reception
desk is simply forwarding the sealed envelope on to the shared noticeboard
without opening it. **Bottom line:** the offer is now genuinely live on
the network, ready to be found.

---

### Tab 2 — Discover (2 hops)

**Hop 1 of 2 — BuyerApp → beckn-router**
*Badge: 200 · ACK.*
The buyer's app is searching, going out its own front door
(`/bap/caller/`), envelope labelled `discover`.
Checks that mattered: the form is filled in correctly; the general network
security scan; the correct next address is looked up; sealed as officially
from the buyer. (The "does this break anyone's trading rules" checkpoint
runs here too, but has nothing to do for a plain search — it only actually
matters once you get to selecting or confirming a trade.)
**What's inside:** a deliberately tiny message — basically, "show me
anything on this network tagged as an energy trade offer." No contract
details yet, because there isn't a contract yet — just a search.
**Bottom line:** the buyer is looking, independently, with nobody having
pushed this offer at them.

**Hop 2 of 2 — beckn-router → Catalog/Discovery**
*Badge: 200 · ACK.*
Same pure hand-off as Publish's second hop — no checklist, no payload
shown. Behind the scenes, the noticeboard finds the seller's offer and
hands it back to the buyer. **Bottom line:** the buyer can now see the
seller's offer sitting on the network.

---

### Tab 3 — Init (8 hops)

**Hop 1 of 8 — BuyerApp → onix-buyerapp**
*Badge: 200 · ACK.*
The buyer's app is starting the actual conversation, out its own front door
(`/bap/caller/`), envelope labelled `init`.
Checks that mattered: a self-check against the trading rules already
attached to the offer; form filled in correctly; general security scan;
next address looked up; sealed as from the buyer.
**What's inside:** the first real draft of a contract — status **DRAFT**.
It states exactly how much the buyer wants: 20.5 units from the first
slot, 15.5 from the second. And it spells out, in plain text, all four
real names involved: the buyer's company, the seller's company, the
buyer's electricity company (labelled `TEST_DISCOM_BUYER` for this test
run), and the seller's electricity company (`TEST_DISCOM_SELLER`) — plus a
link to the actual rulebook document that governs this trade.
**Bottom line:** the buyer is formally saying "here's exactly what I want,
and here's who I am."

**Hop 2 of 8 — onix-buyerapp → beckn-router**
*Badge: 200 · ACK.*
No checklist, no payload. Notice the **Path** field here just says `Host:
sellerapp.example.com` instead of a door name — that's simply the address
label the reception desk reads to know which side to forward this to.

**Hop 3 of 8 — beckn-router → onix-sellerapp**
*Badge: 200 · ACK.* Arrives at the seller's own receiving door,
`/bpp/receiver/`.
Checks that mattered: an ID check confirming this genuinely came from the
buyer; general security scan; next address looked up; form filled in
correctly; **and the one that matters most** — the seller's guard fetches
the seller's own real rulebook and checks whether the buyer's electricity
company is on the approved list. **It passes, this time.** (A note on
screen calls this out directly: this is the exact same checkpoint that
rejects a trade later on Tab 6 — remember this moment.)
**What's inside:** the exact same draft contract from Hop 1 — same buyer
request, same four names — just having now safely arrived at the seller's
side.
**Bottom line:** this is the moment the message physically reaches the
seller's side and passes their trust check.

**Hop 4 of 8 — onix-sellerapp → SellerApp**
*Badge: 200 · ACK.* Path is blank — *"→ business logic."*
No checklist, no payload box. A short note explains: this is a
synchronous "got it," and the real answer follows separately.
**Bottom line:** the seller's guard hands the now-trusted message to the
seller's own app. Nothing has been decided yet — that's Hop 5.

**Hop 5 of 8 — SellerApp → onix-sellerapp**
*Badge: async* — this is one of those separate, sent-back-later messages
from Part 5. Envelope labelled `on_init`, going out the seller's own
front door (`/bpp/caller/`) this time.
Checks that mattered: form filled in correctly; general security scan;
next address looked up; sealed as from the seller. (The trading-rules
checkpoint and the ledger-copying checkpoint both ran but had nothing to
do for `on_init` specifically.)
**What's inside:** a short acknowledgement — the contract is still
**DRAFT**, the seller is simply confirming it received and understood the
request. The real negotiation content comes later, on Tab 4.
**Bottom line:** this is the seller's *actual* reply finally being sent —
not the earlier "got it," a genuinely new message, going the opposite
direction.

**Hop 6 of 8 — onix-sellerapp → beckn-router**
*Badge: async.* No checklist, no payload. Path reads `Host:
buyerapp.example.com` — the reception desk forwarding the reply back
toward the buyer, the opposite direction from Hop 2.

**Hop 7 of 8 — beckn-router → onix-buyerapp**
*Badge: async.* Arrives at the buyer's own receiving door,
`/bap/receiver/`.
Checks that mattered: ID check confirming this genuinely came from the
seller; general security scan; next address looked up; form filled in
correctly. (The two trading-rules/ledger checkpoints run but don't apply
to `on_init`.)
**What's inside:** the same short acknowledgement from Hop 5, unchanged.
**Bottom line:** the buyer's side has now received the seller's real
reply.

**Hop 8 of 8 — onix-buyerapp → BuyerApp**
*Badge: 200 · ACK.* Path is blank — internal hand-off, no checklist, no
payload. **Bottom line:** it lands at the buyer's own app. Both sides now
genuinely know who the other is. Next: actually confirming the trade.

---

### Tab 4 — Confirm (11 hops)

**Hop 1 of 11 — BuyerApp → onix-buyerapp**
*Badge: 200 · ACK.* Out the buyer's own front door (`/bap/caller/`),
envelope labelled `confirm`.
Checks that mattered: buyer-side self-check against the trading rules;
form filled in correctly; general security scan; next address looked up;
sealed as from the buyer.
**What's inside:** the contract, trimmed down to just what's changing —
still **DRAFT**, but a payment record has now appeared for the first
time, naming the seller's own real bank account as the eventual payee.
The payment plumbing is wired in from this point on, even though nothing
has actually been paid yet.
**Bottom line:** the buyer is saying "yes, I want to go ahead with this,"
for real.

**Hop 2 of 11 — onix-buyerapp → beckn-router**
*Badge: 200 · ACK.* No checklist, no payload — pure forwarding, same as
before, addressed toward the seller's side.

**Hop 3 of 11 — beckn-router → onix-sellerapp**
*Badge: 200 · ACK.* Arrives at the seller's receiving door,
`/bpp/receiver/`.
Checks that mattered: ID check; general security scan; next address
looked up; form filled in correctly; **and the trading-rules check again**
— worth noticing out loud: this isn't a one-time check that gets
forgotten, it re-runs on every single trade-forming step (searching for
offers doesn't need it, but selecting, initiating, and confirming all get
the same scrutiny, every time).
**What's inside:** the same payment-ready contract from Hop 1, now safely
arrived at the seller's side.
**Bottom line:** the seller's side receives and re-checks the confirmation
request.

**Hop 4 of 11 — onix-sellerapp → SellerApp**
*Badge: 200 · ACK.* Path blank — internal hand-off. A note flags what's
coming: both companies are about to log this trade into their own
official notebooks, independently.
**Bottom line:** the seller's own app now has the confirmed trade in hand.

**Hop 5 of 11 — SellerApp → onix-sellerapp**
*Badge: async.* Envelope labelled `on_confirm`, out the seller's own front
door.
Checks that mattered: form filled in correctly; general security scan;
next address looked up; sealed as from the seller; **and, for the first
time, the record-keeping checkpoint actually fires** — a note on screen
explains it now forwards a copy of this trade both to the seller's own
company's notebook *and* directly out to the real, internet-hosted
national receipts office.
**What's inside:** the contract's status has flipped from **DRAFT** to
**ACTIVE** — the trade is genuinely locked in now. It also names, in
plain text, the exact internet address of the seller's own electricity
company's record-keeping service — that's literally the address the next
hop delivers a copy to.
**Bottom line:** this is the real confirmation being sent back — and the
paper-trail machinery switching on for the first time.

**Hop 6 of 11 — onix-sellerapp → the seller's electricity company's own
ledger (via the reception desk)**
*Badge: async.* No checklist shown. A note explains: this is a real,
separate delivery, landing at the seller's own electricity company's
official record-keeping system.
**What's inside:** the same "trade is now ACTIVE" message from Hop 5,
copied here.
**Bottom line:** the seller's electricity company now has its own,
independent record that this trade happened.

**Hop 7 of 11 — onix-sellerapp → the real, internet-hosted national
receipts office**
*Badge: async.* No checklist shown. A note flags this as the exact hop
that was independently double-checked afterward, using entirely different
login credentials — and the trade really was found sitting there.
**What's inside:** the same "trade is now ACTIVE" message, copied out to
the real internet — not through the local reception desk at all, straight
out to the public service.
**Bottom line:** this is the credibility moment — real proof this isn't a
simulation.

**Hop 8 of 11 — onix-sellerapp → beckn-router**
*Badge: async.* No checklist, no payload. The main confirmation message
continues its own separate journey back toward the buyer — the two
record-keeping copies didn't interrupt or delay it.

**Hop 9 of 11 — beckn-router → onix-buyerapp**
*Badge: async.* Arrives at the buyer's own receiving door,
`/bap/receiver/`.
Checks that mattered: ID check; general security scan; next address
looked up; form filled in correctly; **and the record-keeping checkpoint
fires again here too** — because the buyer's side needs its own,
independent record with its own electricity company, separate from
whatever the seller just did.
**What's inside:** the same "trade is now ACTIVE" message, now arrived at
the buyer's side.
**Bottom line:** the buyer's side receives the real confirmation, and its
own record-keeping kicks off in parallel.

**Hop 10 of 11 — onix-buyerapp → the buyer's electricity company's own
ledger (via the reception desk)**
*Badge: async.* No checklist shown. A note explains this is a real, local
delivery, recorded at the buyer's own electricity company.
**What's inside:** the same "trade is now ACTIVE" message, copied here.
**Bottom line:** the buyer's electricity company now has its own record
too — two separate companies, two separate notebook entries, neither one
waiting on the other.

**Hop 11 of 11 — onix-buyerapp → BuyerApp**
*Badge: 200 · ACK.* Path blank — internal hand-off, no checklist, no
payload.
**Bottom line:** it lands at the buyer's own app. The trade is now
**ACTIVE** on both sides, and both electricity companies have their own
record of it.

---

### Tab 5 — Settle (5 hops)

**Hop 1 of 5 — SellerApp → onix-sellerapp**
*Badge: async.* Envelope labelled `on_status`, out the seller's own front
door.
Checks that mattered: form filled in correctly; general security scan;
next address looked up; sealed as from the seller; **and, most
importantly, the trading-rules checkpoint** — this is the exact step
where the actual money math gets computed, live. A note on screen spells
out the arithmetic in full: 18.5 units × ₹12.5, plus 14.2 units × ₹14.5,
equals ₹437.15 — computed here, not typed in by anyone.
**What's inside:** the full, final picture. Status is now **COMPLETE**.
The actual delivered amounts appear — 18.5 units in the first slot, 14.2
in the second (a little different from what was originally requested,
because real-world delivery rarely matches a request exactly). Right
below that is the payoff: the seller's side shows **+₹437.15**, the
buyer's side shows **−₹437.15** — the two numbers cancel out exactly to
zero. Beneath that, a real payment record shows status **SETTLED**, with
an actual reference number.
**Bottom line:** this is the single most important payload in the whole
demo — start to finish, real delivery to real money, in one message.

**Hop 2 of 5 — onix-sellerapp → beckn-router**
*Badge: async.* No checklist, no payload — pure forwarding, back toward
the buyer.

**Hop 3 of 5 — beckn-router → onix-buyerapp**
*Badge: async.* Arrives at the buyer's receiving door,
`/bap/receiver/`.
Checks that mattered: ID check; general security scan; next address
looked up; form filled in correctly; the trading-rules checkpoint runs
again here too, but this time it isn't computing anything new — the
numbers were already worked out on the seller's side and simply pass
through; **and the record-keeping checkpoint fires**, pushing this final
settled result to the buyer's own electricity company.
**What's inside:** the same complete, settled payload from Hop 1,
unchanged.
**Bottom line:** the buyer's side receives the final numbers exactly as
the seller's side computed them — nothing recalculated, nothing disputed.

**Hop 4 of 5 — onix-buyerapp → the buyer's electricity company's own
ledger (via the reception desk)**
*Badge: async.* No checklist shown, no note.
**What's inside:** the same final settled payload, copied here.
**Bottom line:** the buyer's electricity company now has the fully
settled record too — the real delivered quantities and the real amount
owed.

**Hop 5 of 5 — onix-buyerapp → BuyerApp**
*Badge: 200 · ACK.* Path blank — internal hand-off, no checklist, no
payload.
**Bottom line:** the complete, real lifecycle is done — publish, discover,
negotiate, confirm, settle. Every number along the way was computed by
the network itself, not typed in by a person.

---

### Tab 6 — Rejected (3 hops)

**Hop 1 of 3 — BuyerApp → onix-buyerapp**
*Badge: 200 · ACK.* Out the buyer's own front door (`/bap/caller/`),
envelope labelled `init` — the exact same kind of message as Tab 3, Hop 1.
Checks that mattered: a self-check against the trading rules — and it
passes, because the buyer's own side has no way of knowing the *seller's*
private list of approved companies yet; form filled in correctly; general
security scan; next address looked up; sealed as from the buyer.
**What's inside:** the same shape as a normal first-draft contract, except
one detail is different: the buyer's electricity company is now listed as
`TEST_OUTSIDE_DISCOM` instead of the approved `TEST_DISCOM_BUYER` — the
one detail that's about to get this trade rejected.
**Bottom line:** this message leaves the buyer's side looking completely
normal — nothing looks wrong from here.

**Hop 2 of 3 — onix-buyerapp → beckn-router**
*Badge: 200 · ACK.* No checklist, no payload — ordinary forwarding, same
as always.

**Hop 3 of 3 — beckn-router → onix-sellerapp — the rejection**
*Badge: **400 · NACK**, shown in red.* Arrives at the seller's receiving
door, `/bpp/receiver/`.
Checks that mattered: ID check; general security scan; next address
looked up; form filled in correctly; **and then the trading-rules
checkpoint — the exact same one that let the real trade through earlier —
fetches the seller's real rulebook, checks the list, and this company
isn't on it.** A note on screen states plainly: the contract never forms,
and the seller's own app never even gets to see this attempt — it's
stopped one layer earlier, at the guard.
**What's inside:** the actual rejection notice, word for word: the
buyer's electricity company isn't allowed to trade with this seller's
customers on this network — and it even lists which companies *are*
allowed.
**Bottom line:** unlike every other rejection-worthy check in this demo,
this one doesn't wait for a separate reply later — it happens
**instantly, in this same message**. Nobody owes anybody anything; the
trade simply never happened.
