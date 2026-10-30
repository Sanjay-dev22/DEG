# V2G on IES/DEG — case, status, and staged build plan

**Status: active plan, registration in progress.** This started as a
pre-build case (should we even do this?). It's now a staged build plan —
registration is underway, and the sections below lay out exactly what gets
built, in what order, using the real schemas we've already found, not
placeholders.

---

## 1. What's actually missing — precise, not "V2G doesn't exist"

It's tempting to say "IES/DEG has no V2G support." That's not accurate, and
overclaiming it would be the same mistake corrected earlier in the UC3
work. The precise picture, verified directly against the `ies-specs`
branch source (not assumed):

**What already exists, real and detailed:**

| Piece | Where | What it actually contains |
|---|---|---|
| Resource capability model | `specification/schema/EnergyResourceEVCharger/v1.1/` | A real type discriminator: `EV_CHARGER` (one-way) vs **`EV_V2G`** (bidirectional). Fields for `maxImport`/`maxExport`, `connectorType`, `controlProtocol` (including `ISO_15118_20`), and `v2xProtocol` (`CHAdeMO_V2G`, `CCS_BPT`, `ISO_15118_20_AC_BPT`, `ISO_15118_20_DC_BPT`) — correct, current V2G engineering terminology, not placeholder text. |
| Control-rights / consent model | `specification/schema/EnergyProgramEnrollment/v2.0/` | A W3C Verifiable-Credential-based enrollment flow with a named consent type, **`DER_CONTROL`** — exactly "consent to control DER devices for demand response" — plus credential verification, conflict detection, and revocation, all already built generically for any DER. |
| Settlement mechanism | `devkits/demand-flex/` | A complete, running flow: utility posts a flexibility need, an aggregator commits capacity, real interval-level settlement math (OPA/Rego policy) pays out based on metered baseline-vs-actual. Technology-neutral — never named "V2G," but functionally identical to it. |

**What's confirmed absent, by direct search of every example file in the
repository, not by assumption:**

- `EV_V2G` is never used as a `type` value in any actual protocol message
  anywhere — only inside the schema-definition files themselves.
- `DER_CONTROL` consent appears in exactly one real example, and in that
  one instance it is explicitly declined (`"granted": false`, *"not
  applicable for this enrollment"*). Never exercised as granted.
- Onboarding's own persona guide gives every *other* persona a full
  narrative — **section 11.8, "Prosumer – EV with V2G," is one sentence**,
  no message flow.
- `The_Vision.md` names Vehicle-to-Grid as "Illustrative Use Case #5" — an
  aspiration in the founding vision doc, never built out since.

**The actual gap:** the pieces are real and well-designed. Nobody has ever
demonstrated `EnergyResourceEVCharger` (`EV_V2G`) enrolled via
`EnergyProgramEnrollment` (`DER_CONTROL`, actually granted) participating
in a real settled flexibility event. That composition has never been
built, tested, or documented anywhere.

---

## 2. Why it matters

**Technical/standards reason.** An unexercised schema composition is a real
risk for exactly the reason Tariff Intelligence exists to prevent: two
teams implementing "V2G on IES" independently, both schema-conformant,
could diverge — because nothing has ever forced the composition to run
end-to-end. Proving it once, publicly, removes that ambiguity for everyone
after.

**Timing/market reason.** The EU's AFIR regulation mandates ISO 15118-20
(bidirectional-capable) charging infrastructure for all new/refurbished
public and private chargers from 1 January 2027 — real, near-term, not
speculative. A GM-commissioned study (E3) found V2G could deliver 5–15x
more value per vehicle than one-way managed charging (~$7B US potential by
2030), gated currently by regulatory/tariff barriers, not technology. Real
V2G pilots are already running (China: 30 pilots/9 cities; Netherlands:
500 bidirectional Renaults, pilot → fully commercial; US: Maryland's V2G
interconnection rules + the first residential V2G pilot with Ford F-150
Lightnings; UK: Nissan's G99 grid-code certification).

**Position reason.** A company already selling EV charge-communication
control units, power electronics, and fleet-charging software (Bosch's
real, current product line, verified earlier in this thread) is better
positioned than most to build and validate this composition — real
hardware/software already touching both ends of the flow.

---

## 3. Current status

- DeDi account created; namespace **`nharuvi-energy`** claimed.
- Target subdomain: **`beckn.nharuvi.com`** (kept separate from the main
  `nharuvi.com` site/CRM — different hosting, DNS-verified independently).
- Hit a "domain not in global registry" error during the DNS verification
  step — not something the official process documents as expected
  behaviour, so treated as a platform-side issue to raise with DeDi
  support, not a mistake in our setup.
- Not yet done: credential-signing keypair (§1.2, EC P-256), `did.json`
  publish (§1.3), Beckn Ed25519 keypair (§1.5), subscriber record (§1.6),
  or the Secretariat application (§1.7) — all blocked behind the domain
  verification getting unstuck.
- **Role decision, made:** we register and build as a **BAP** first — the
  simpler side to demonstrate ("I need a service, I discover who can
  provide it"), not a BPP with the standing obligation to answer live
  incoming traffic reliably. Becoming both BAP and BPP is a real, sensible
  later stage (an aggregator naturally needs both), not the starting point.

---

## 4. The staged build plan — corrected sequencing, real schemas throughout

Reworked from an earlier planning pass that had good staging instinct but
placeholder message shapes (`"intent": {"energy": {"power": "5 kW"}}` —
never a real IES/DEG schema). Below, every stage uses the actual schema
objects already verified in this research, not invented ones.

### V0 — Finish registration (in progress, §3 above)

Blocked on the DeDi domain error. Nothing past this point is reachable
until `beckn.nharuvi.com` is verified and a subscriber record is
published.

### V1 — Prove our own identity works at all, zero V2G content

**Goal:** one real `discover` → `on_discover` round trip using **our own
registered identity** (`nharuvi-energy` / `beckn.nharuvi.com`), not the
shared devkit placeholder (`bap.example.com`) UC3 quietly relied on. This
is the actual untested step — everything else after it we've already done
once, just under a borrowed identity.

Deliberately no EV, no V2G, no Demand Flex yet. Success = our identity
gets a real response back from a real counterparty on the network.

### V2 — Build the simulated EV as a real schema object, not a mock

**Goal:** author a real `EnergyResourceEVCharger` object, `type: EV_V2G`,
carrying real fields — `maxImport`/`maxExport`, `connectorType`,
`v2xProtocol: ISO_15118_20_AC_BPT` — plus a software model of what a real
EV needs to track: state of charge, capacity, availability window, owner
consent. This is a **digital twin**, not a fake grid — DEG's own model is
explicit that the digital layer never carries physical energy, it carries
the contract/order that leads to it; the simulation lives entirely on the
digital side, which is exactly the right first PoC.

### V3 — Grant `DER_CONTROL` consent for real (never done before, anywhere)

**Goal:** run the simulated EV through `EnergyProgramEnrollment`, actually
setting the `DER_CONTROL` consent to granted — the one thing confirmed
absent from every real example in the entire repository. This alone is a
genuinely new artifact: nobody has published a working example of this
consent type being exercised, only declined.

### V4 — Real Demand Flex transaction against the enrolled EV

**Goal:** reuse the already-proven `devkits/demand-flex/` sandbox (same
one from earlier hands-on work) — a utility posts a flex need, our BAP
discovers it, commits the enrolled `EV_V2G` charger's capacity, and lets
the real settlement rego run. Two things get tested here, not one:

1. Does the composition work at all (the core gap from §1).
2. **The open technical question**: does the settlement math correctly
   handle a meter reading that goes properly negative (real discharge),
   or only "reduced to zero" (curtailment)? Cheap to test in isolation
   before the full flow — feed a negative "actual" reading into the
   existing policy and see what happens. This is exactly the kind of
   concrete, previously-unknown finding UC3's "marginal vs. blended
   surcharge" gap was — worth deliberately hunting for here too.

### V5 — Layer in the protocol conversations below IES, kept clearly separate

**Goal:** make explicit that there are three distinct conversations, not
one — a distinction worth keeping sharp in any presentation of this work:

- **Conversation A** — BAP ↔ BPP, the IES/Beckn business layer (discovery,
  contract, settlement). Everything in V1–V4 above.
- **Conversation B** — EVCC ↔ SECC, the ISO 15118-20 layer (does this
  specific car and this specific charger actually negotiate and execute
  power transfer). A real, open-source reference implementation exists to
  draw on for this layer: **RISE-V2G** (github.com/SwitchEV/RISE-V2G).
- **Conversation C** — EVSE ↔ backend, the OCPP layer (does the charger
  report its status to *some* management system).

V5's job is to simulate B and C at a basic level so the full chain is
visible end to end, without requiring real hardware or a full RISE-V2G
integration on the first pass.

### V6 — Add the OpenADR-shaped grid trigger

**Goal:** model the "grid needs flexibility" event as what it already is
under the hood — `DemandFlexNeed` is explicitly built on `BecknTimeSeries`,
which is itself explicitly "Based on OpenADR 3.1.0" (confirmed earlier in
this research, not asserted here). This is the part that ties directly
into Bosch's own existing OpenADR/demand-response knowledge, rather than
treating OpenADR as a separate, disconnected research thread.

### The actual research deliverable — not "we built a V2G demo"

Once V1–V6 work, the honest, scientifically defensible output is a
**comparison**, not a victory lap: does routing this through IES/Beckn
(identity, discovery, consent, settlement) actually add measurable value
over a conventional point-to-point integration (utility → aggregator →
proprietary API → charger), or not? Count real things — number of
bilateral integrations avoided, whether a new provider can be added
without new code, traceability of the consent/settlement trail. If the
open-layer approach doesn't show a real advantage, that's a legitimate,
reportable result too — a stronger and more credible position than
assuming the answer going in.

---

## 5. Honest scope check

- This is real, buildable work, similar shape and size to UC3 — a longer
  staged sequence (V1–V6) rather than one flow, because we deliberately
  chose to de-risk in small steps instead of jumping straight to the full
  composition.
- Same non-commercial channel as UC3 if this gets contributed back
  (public schema/example review, not a paid contract). The commercial
  upside is separate and downstream: being the vendor who can point to a
  *proven* composition once utilities or fleet operators start asking
  "does this actually work."
- Terminology note, flagged not confirmed: an earlier planning pass
  claimed Beckn v2 is moving from BAP/BPP to CN/PN (Consumer Node/Provider
  Node) naming. Every real example message read in this research — Demand
  Flex, EV_Charging v2, P2P Trading, all `"version": "2.0.0"` — uses
  `bapId`/`bppId` throughout, never CN/PN. Treat that claim as unverified
  until seen in a primary source, not as settled.

---

## 6. Immediate next step

Unblock V0 (DeDi domain verification via their support), then V1 —
nothing V2G-specific is reachable until our own identity can complete one
real round trip on the network.
