# India Energy Stack — Technical Documentation Summary

Source: https://ies.recindia.org.in/docs (GitBook, mirrors india-energy-stack.gitbook.io/docs)
Full raw pages saved in: `ies-docs-raw/` (65 pages downloaded as markdown)
Captured: 2026-08-18

## Governance / contact
- Chief Patron: Nandan Nilekani. Nodal Agency: REC Limited. Knowledge Partner: FSR Global.
- IES Secretariat: `ies.secretariat@fsrglobal.org` — REC (Nodal Agency): `ies@recindia.com`
- GitHub (issues/discussions/contributions): https://github.com/India-Energy-Stack/ies-accelerator
- Full report PDF: https://india-energy-stack.github.io/ies-accelerator/ies-report.pdf (saved locally as `ies-report.pdf`)
- Doc index (llms.txt): https://india-energy-stack.gitbook.io/docs/llms.txt

## The 5 building blocks (per docs — supersedes the "5 building blocks" language in the March v0.4 Strategy Document, which is now slightly reworded here)
Identifiers, Registries, Exchange, Verifiable Credentials, plus a cross-cutting posture of Security, Consent, and Machine Readable Rules.

## The 3-step interaction model (Register → Discover → Exchange)
1. **Register** — verifiable digital identity. Every participant publishes a `did:web` (W3C Decentralized Identifier) at `https://<domain>/.well-known/did.json`, and lists their org in the **DeDi** directory (`publish.dedi.global` / `explore.dedi.global`, docs at `docs.nfh.global`). Done once. ~1-2 days.
2. **Discover** — Beckn Protocol v2 interaction. Systems look each other up, verify authenticity, agree terms. Uses the **Beckn ONIX** adapter (open source, ready-made — participants configure, don't build). No bilateral agreement needed per pair.
3. **Exchange** — data moves over the signed Beckn channel, shaped by published IES schemas built on open standards (DLMS/COSEM for meter data, IEEE 2030.5 for solar/storage, OpenADR for demand response/policy). Where a durable record is needed, produces a **W3C Verifiable Credential** the holder keeps (e.g. in DigiLocker).

## The two-part Adapter (what a TSP actually builds)
- **Part 1 — engine (ready-made, you don't build it)**: one per capability.
  - **ONIX** — for Beckn-network / data-exchange use cases (signs, verifies, routes, does registry lookups).
  - **OpenCred** — for credential use cases (issue / verify / revoke W3C Verifiable Credentials).
- **Part 2 — your mapping (the ONLY code you write)**: translates your/your client's internal data formats (CIS, MDM, HES, DERMS, ERP, billing) into IES schema shapes, feeding Part 1. **Typically 200–1,000 lines of code per use case.** This is explicitly, repeatedly stated as "the only IES work where you write code — the rest is configuration."

## Prerequisites before building anything (same for every participant)
1. A domain/subdomain you control + DNS access (for `did.json` + DeDi TXT verification).
2. One Linux host that can run Docker + serve HTTPS.
3. One engineer (not a team) — total setup effort is small.
4. Generate an EC P-256 signing keypair (for credentials, via OpenCred) and/or an Ed25519 keypair (for Beckn messages, via ONIX) — these are deliberately separate keys/identities.
5. Register a DeDi namespace, verify domain via DNS TXT record.
6. (Beckn participants only) Publish a Beckn subscriber record (BAP/BPP role, callback URL, signing key) in DeDi, then email the IES Secretariat to get **referenced into an IES network** (`ies-data-sharing-network`, `ies-p2p-trading-network`, or `ies-der-integration-network` — each with prod/test variants).

**Explicitly NOT needed**: a new database, a new compliance filing, a new procurement contract, a licence fee, or any prior approval before starting on the sandbox — "get something working, then talk to the IES Secretariat about going to production."

## Timeline (validated by the actual 4-DISCOM pilot — see main page)
The 4 pilot DISCOMs went from cold start to 4 demonstrated use cases in **30 days total**. Breakdown: Register 1–2 days; stand up engines 1–3 days; adapter for first use case 1–3 weeks; conformance 1–2 days; each subsequent use case only a few days to a week (identity/engines/network membership are all reused).

## Devkit (where a TSP actually starts coding)
```bash
git clone https://github.com/beckn/DEG.git
cd DEG/devkits/data-exchange/install
docker compose up -d
```
This spins up a full local sandbox: two ONIX adapters (onix-bap, onix-bpp), two stand-in sandbox apps, a Caddy router, Redis — pre-wired with placeholder identities so a TSP can test a complete `confirm` → `on_confirm` round trip on a laptop before plugging in real identity/data. Each use case ships matching Postman collections (`uc1-meter-data`, `uc2-regulatory-data`, `uc3-tariff-policy`) to fire real requests against the sandbox.

Once local sandbox works: swap in real identity/keys → test over public internet via ngrok tunnel → replace the sandbox app with your own webhook service (this webhook IS your Part-2 mapping) → run conformance checklist → email Secretariat for production network reference.

## The 5 sandbox use cases with published schemas + implementation guides (as of this docs snapshot)
1. **Consumer Energy Passport** — smallest schema, "consumer-facing value is immediate" — recommended first use case for a new TSP. Schema: `ElectricityCredential v1.2`.
2. **Consumer Meter Digest** — builds on the Passport adapter, small extra surface. Schema: `MeterDataCredential v0.6`.
3. **Smart Meter Data Exchange** — "solves a tangible AMISP-DISCOM pain; mostly DataOps work." Schema: `MeterData v0.6`.
4. **DER Visibility** — for rooftop/EV registration priorities. Schema: `ElectricityCredential v1.2` (`energyResources[]`).
5. **P2P Energy Transaction** — already piloted/demoed (see main-page notes).

⚠️ **All 4 of the "DISCOM Challenge" use cases (DER Visibility, Consumer Energy Passport, Consumer Meter Digest, Smart Meter Data Exchange) have already been built and demoed by 4 real DISCOMs** (PVVNL, APEPDCL, DGVCL, Tata Power) in a 30-day challenge that ran 21 May–21 June 2026. P2P Energy Transaction was separately piloted and demoed at the India AI Impact Summit 2026. **This means all 5 of the "core" sandbox use cases already have real reference implementations from the pilot cohort** — a new TSP building one of these now would be replicating proven ground, not opening new territory.

## The 2 "Draft / Work-in-Progress" use cases — THESE MAP DIRECTLY TO THE TWO EOIs THE USER ASKED ABOUT AND ARE STILL OPEN/UNPROVEN

### UC2: DISCOM Regulatory Filing (maps to the "ies-eoi-uc2-rde-ra" EOI — Regulatory Data Exchange / Regulatory Analytics)
- **What it is**: A DISCOM's Aggregate Revenue Requirement (ARR), true-up, FPPCA, or MYT compliance filing submitted to its State Electricity Regulatory Commission (SERC) as a structured, signed `ArrFiling v0.5` object over IES Data Exchange — replacing today's PDF/Excel submissions that SERC staff manually re-key.
- **Actors**: DISCOM = BPP (data provider/filer); SERC = BAP (data consumer/regulator). This is the *inverse* direction from Smart Meter Data Exchange, but reuses the same ONIX stack, identity, and registries.
- **Schema (`ArrFiling v0.5`)**: `filingId`, `filingType` (MYT/ANNUAL/TRUE_UP/REVISED), `licensee`, `regulatoryCommission`, `controlPeriodStart/End`, `currency` (always INR), `unitScale` (CRORE/LAKH/ABSOLUTE), `status`, `fiscalYears[]` → each with `yearType`, `amountBasis`, `lineItems[]` → each with `lineItemId`, `category` (VARIABLE/FIXED/INCOME/SUB_TOTAL/ARR/ADJUSTMENT), `subCategory`, `head`, `amount`, `formReference`, `componentOf`.
- **Status**: 🚧 Work in progress — schema is a "draft for technical review." Open items: cost-category enum still converging across states, workbook-attachment convention still being agreed, cross-filing references to Policy as Code's `policyID` still being aligned.
- **Concretely what a TSP would build**: (1) mapping table from a real DISCOM's ARR PDF/Excel line items → `ArrFiling` JSON fields, (2) a BPP handler wired into ONIX that responds to a SERC's `confirm` request with the structured filing, (3) schema validation against `schema.json`, (4) at least one real prior-year filing converted and schema-validated as proof.
- **Example payload structure and JSON Schema**: at `github.com/India-Energy-Stack/ies-accelerator` under `schemas/ArrFiling/v0.5/`.

### UC3: Policy as Code (maps to the "ies-eoi-uc3-policy-code" EOI)
- **What it is**: Any authority policy — tariff orders (flagship sub-use-case, called "Tariff Intelligence"), dispatch guides, deviation penalties, DR programme rules, data-exchange SLAs — published once as a signed, machine-readable `IES_Policy` object by the issuing authority (a SERC, CEA, load-despatch centre), consumed directly by DISCOM billing systems, consumer apps, and smart meters — instead of every DISCOM manually transcribing a PDF tariff order into its own billing system.
- **Actors**: SERC (or any policy authority) = BPP (publisher); DISCOM billing systems / app developers / smart meter firmware = BAP (consumers). Publication is typically open/public (`accessMethod: INLINE`, settlement value `0`) — anyone can pull and verify with the issuer's public key.
- **Schema (`IES_Policy`)**: `id` (per-version URN), `policyID` (stable handle across amendments), `policyName`, `policyType` (currently only `TARIFF` or `DISPATCH_GUIDE` in the live enum — others like deviation penalties are still draft), `programID`, `samplingInterval` (ISO 8601 recurrence). For tariffs: `energySlabs[]` (progressive tiers: `id`, `start`, `end`, `price`) and `surchargeTariffs[]` (time-of-day adjustments: `id`, `recurrence`, `interval`, `value`, `unit` = PERCENT or INR_PER_KWH).
- **Status**: 🚧 Work in progress — "Tariff Intelligence" sub-use-case is "Live or staged"; schema currently lives upstream at `beckn/DEG` repo (`ies-specs` branch), migrating to a first-class `schemas/Tariff/v0.x/` — no breaking change expected, just a new canonical URL.
- **Concretely what a TSP would build**: (1) author a real SERC tariff order (e.g. a residential telescopic tariff with time-of-day surcharges) as `IES_Policy` JSON-LD, (2) a BPP publisher stub that signs and catalogues it, (3) a small **billing-engine evaluator** — "look up the applicable slab, look up the matching time-of-day surcharge, apply" — that consumes the same policy and computes a bill, (4) validate two independent billing implementations produce identical results from the same policy object.
- **Example payloads**: `github.com/beckn/DEG` → `devkits/data-exchange/uc3-tariff-policy/examples` (includes a real Mumbai Residential example and a Karnataka LT2 Industrial ToD example).

**Both UC2 and UC3 are explicitly still labeled "Work in Progress" / draft in the docs** — meaning, unlike the 5 core use cases (which 4 real DISCOMs already built and demoed), these two are NOT yet proven with a real reference implementation. This is where genuine open ground still exists for a new TSP.

## Conformance — what "done" actually means
A conformance pass only proves: (1) your `did:web` resolves and is well-formed, (2) network membership is correctly registered (Beckn participants), (3) at least one use case validates against the canonical JSON Schema and completes a real end-to-end exchange with a sandbox/testnet counterparty, (4) signatures verify. It explicitly does NOT prove full JSON-LD conformance, full external-schema conformance (several schema families — `MeterData/v0.6`, `MeterDataCredential/v0.6`, `OutageNotification/v0.1` — reference externally-hosted structures that the local validator only stubs permissively), or production certification (that's a discretionary determination made by the IES Secretariat, not something any script confers).

Command to run local validation:
```bash
python3 scripts/validate_schema.py schemas/<Family>/<version>/schema.json my-test-output.json
```

Command to run the Beckn conformance suite against a sandbox peer:
```bash
cd DEG/devkits/data-exchange/conformance
./run.sh --subscriber did:web:ies.discom.example --usecase consumer-energy-passport
```

## Submitting for production (after conformance passes)
Email the IES Secretariat with: your `did:web`, DeDi namespace, testnet conformance report, and implemented use cases. The Secretariat spot-checks your sandbox endpoints, then writes a production reference entry. **The docs themselves flag uncertainty about whether this pipeline is currently staffed/reachable** — a notably candid caveat repeated on multiple pages: "Whether the IES Secretariat, the sandbox, and the production/test network registries... are currently staffed and reachable is not something this repository can verify on its own."

## TSP Pathway — role-specific guidance (docs/pathways/tsp.md)
Written specifically for: **AMISPs, meter/EV-charger/inverter OEMs, system integrators, and analytics vendors** — i.e., exactly the kind of company the user is exploring becoming.

Key points:
- A TSP typically writes the Part-2 mapping **on behalf of a DISCOM client** — the DISCOM owns the identity, the TSP does the engineering.
- If a TSP's product serves **multiple DISCOMs**, it needs to think about identity two ways: each DISCOM client keeps its own `did:web`; but if the TSP's platform itself signs a credential or publishes a Beckn catalogue as "provider" (e.g. an AMISP signing a `MeterDataCredential` in its own name), the TSP needs **its own separate `did:web`** — conflating the two breaks the trust chain.
- **AMISPs** map their HES/MDM output into 8 `MeterData v0.6` compact profiles: `CUSTOMER`, `INTERVAL`, `DAILY`, `MONTHLY`, `BILL_DETAILS`, `INSTANTANEOUS`, `EVENT`, `ALARM`.
- **OEMs** (DER/EV-charger/inverter makers) populate `energyResources[]` in `ElectricityCredential v1.2`, discriminated by device kind: `EnergyResourceGenerator` (solar/wind/hydro/biogas/CHP/fuel cell, mapped to IEC 61970-302 `cim:GeneratingUnit`), `EnergyResourceStorage` (BESS), `EnergyResourceEVCharger` (EV_CHARGER/EV_V2G), `EnergyResourceInverter`.
- Recommended engagement scoping: **test your mapping once per product line, not once per DISCOM client** — a correct mapping against the published schema works unmodified across every client whose data maps to it; per-client re-verification is only needed for client-specific identity/config, not new code.

## Key architectural point for positioning a proposal
IES is explicitly **not** a platform, database, or product a TSP can be hired to "build" wholesale — it's a specification. What REC/FSR actually need from TSPs is: (1) working adapter implementations that prove a specification is implementable against real messy data, (2) for the two still-draft use cases (UC2 Regulatory Filing, UC3 Policy as Code), genuine open technical problems (cost-category taxonomy convergence across states, workbook-attachment conventions, cross-filing references) that a strong technical submission could meaningfully help resolve rather than just replicate.
