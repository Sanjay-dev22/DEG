# P2P Trading — Lightweight Demo App Plan

**Status: planning only. No scaffolding has been started — build begins only
when explicitly told to.**

This supersedes, for now, the production-grade plan in `ARCHITECTURE.md` in
this same folder. That document stays as-is, untouched, as the future
reference if this ever needs to become a real deployable product. **This
document is what we're actually going to build next**: a small, honest,
low-infrastructure app whose only job is to make a live audience *watch* a
real trade happen, right after Grid Pulse has already convinced them the
mechanism underneath is real.

---

## 1. Why build this at all, given Grid Pulse already exists

**Grid Pulse's job is proving the mechanism is real** — real signatures,
real policy engine, real payloads, real settlement math, replayed so anyone
can inspect every field at their own pace. It's *evidence*. It builds deep
trust with anyone technical enough to care about the internals.

**What Grid Pulse structurally cannot do** is show **agency and liveness**,
because it's a scripted replay of one fixed, pre-recorded trade. It cannot
show:
- You, live, typing in a price and quantity of your own choosing and
  watching it actually go out
- Two genuinely separate, independently-running programs reacting to each
  other in real time, with no script driving them
- An audience seeing a rejection happen live, to a request *they* just
  caused, rather than watching a pre-recorded rejection play out

That's the gap this app fills. It turns "I've proven to you this protocol
is real" into "watch me use it, right now, like software." For a
non-technical audience especially, two browser windows visibly talking to
each other live is a completely different experience than watching a
diagram animate through a script.

**Honest caveat:** if the audience is already technical and already
convinced by Grid Pulse's rigor, this mostly adds polish, not new technical
proof — Grid Pulse already proved the mechanism. But if the audience
includes anyone non-technical, or anyone who needs to leave believing "this
could genuinely become a product," this closes exactly that gap.

---

## 2. What this app deliberately is NOT

No Postgres, no Redis, no job queue, no auth/RBAC, no compliance exports, no
Network Operator console, no meter-simulator service running on its own
timer. All of that was correctly identified as solving problems a live demo
in front of an audience doesn't have. See `ARCHITECTURE.md` §7–8 if any of
it becomes genuinely needed later.

---

## 3. What it actually needs — the whole stack

| Piece | Choice | Why this and nothing heavier |
|---|---|---|
| Storage (one per side) | **SQLite**, one small `.db` file | Real database — real inserts/queries, survives a page refresh mid-demo — but zero servers to run, zero new Docker services |
| Backend (one per side) | Small **Node/Express** service | Matches the existing onix/sandbox stack; implements the same webhook contract the stub currently fakes (`/api/webhook/init`, `on_confirm`, `on_status`), but with real logic |
| Live push | **Plain WebSocket** (the `ws` package), no Redis | One seller process, one buyer process, one trade at a time in front of an audience — an in-process event emitter is enough |
| Frontend (one per side) | One simple page each (plain HTML/JS or a tiny React page — no framework ceremony needed) | Only the few actions in §4 below; a single page per side is enough |
| Auth | **None** | Presenter operates both sides themselves; a login screen eats demo time for zero payoff |
| Metering | **A manual "Mark as delivered" button** that computes a randomized `FINAL_ALLOC` on click | Presenter controls pacing — never autoplay during a live demo, same philosophy as Grid Pulse's own ▶ Step control |

That's the entire stack. Nothing added to the existing docker-compose beyond
the two small app services replacing the stub.

---

## 4. Feature list — deliberately minimal

**Seller dashboard (one page):**
- Form: quantity, price per slot → **Publish offer** (really calls
  `catalog/publish` through `onix-sellerapp`)
- Live list: **Incoming requests** — real `init` messages appear the moment
  they arrive (webhook → WebSocket push, no polling)
- **Accept** button per request — fires the real `on_init`/`on_confirm`
- Once active: **Mark as delivered** button → sends the real `on_status`
  settlement
- A running **Earnings** number, updating live

**Buyer dashboard (one page):**
- Live list of published offers (real `discover` results)
- **Buy** button on an offer → fires real `init`
- A per-trade status line: `Pending → Confirmed → Settled`, updating live
- The settlement amount appearing, computed from the real math — never
  typed in

Nothing else. If a feature doesn't make the live demo more convincing, it
doesn't belong in this version.

---

## 5. Suggested demo script (the actual deliverable — the app is just the prop)

1. Grid Pulse first, as already planned — establishes "this is real, here's
   exactly how it works."
2. "Now let's see what that actually looks like as software." Open both
   dashboards side by side.
3. As the seller: type a real quantity/price, publish — audience watches it
   happen.
4. As the buyer (other window): the offer appears live, click Buy.
5. Back to seller: the request appears live in the inbox, click Accept.
6. Click "Mark as delivered" — both screens update to a real, computed
   settlement number.
7. **Strong optional closer**: repeat the buy from a persona that isn't on
   the allowlist, live — audience watches a real rejection happen to
   something *they* just asked you to try, not a canned example. Cheap to
   include (same rejection logic Grid Pulse already visualizes, just
   triggered live) and it's the single most convincing "this isn't smoke
   and mirrors" moment available.

---

## 6. Suggested build order (still small, still no infra creep)

1. **Seller side only**: publish an offer, see it persist in SQLite, see it
   land at `onix-sellerapp` — prove the wiring before building the buyer
   side.
2. **Buyer side**: discover, buy, see the request reach the seller's inbox
   live over WebSocket.
3. **Accept → settle loop**: the Mark-as-delivered button, the real
   settlement math showing up on both screens.
4. **The rejected-persona path**, wired the same way as the happy path.
5. Visual polish pass only after all four above work end-to-end — keep it
   clean and legible, not elaborate.

**No phase begins until explicitly told to start it.**
