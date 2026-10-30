# Research record — aggregation, Bosch V2G, India status

Saved 2026-09-24. This file holds (1) the exact prompt given to the research
agent and (2) the agent's complete final report, unedited.

| | |
|---|---|
| Agent | "Research aggregation, Bosch V2G, India status" (forked from the main session) |
| Ran | 2026-09-23 |
| Duration | about 8 min 14 s |
| Work done | 334 tool calls (web searches/fetches, `gh` calls, local file reads); about 804k tokens |
| Wrote to disk | nothing (read-only task) |

The agent's tool-by-tool transcript is not included here (it is very large and
mostly raw web pages). It lives in the session's task output at
`C:\Users\Sanjay\AppData\Local\Temp\claude\C--Users-Sanjay-Desktop-DEG\72adb1ff-e560-4255-8607-e89a202e24f3\tasks\a02f27f8d2e26365c.output`
and may be cleaned up by the system.

---

## Part 1 — The prompt given to the agent

```text
Research task (read-only — do NOT modify any project files; write no files). The user is following up on the aggregator/VPP/V2G analysis you already produced earlier in this conversation (Virtual Power Plant, actors, non-delivery/manipulation/failure risk answers, "needs a new use case, not a schema patch"). Do not repeat that; go deeper on what they asked now. Today is 2026-09-23; use 2026 in searches and prefer sources from 2024-2026. The user has zero technical background and gets confused by jargon, so write for that reader with worked numeric examples.

Their questions, verbatim in spirit:
(1) "How can electricity from many DERs be coordinated and supplied as something massive, because one person's 1 kW is not going to make sense" — i.e. the actual mechanics of aggregation/orchestration.
(2) "What level has Bosch achieved in V2G?"
(3) "What is currently in practice in India, and what's lacking?"
(4) "Before even V2G, what about normal orchestration and aggregation of energy — but wait, which use case does that come under (in DEG/IES)? If it doesn't, we go into V2G itself as the example."

Do all of the following with REAL fetched sources (WebSearch/WebFetch; also `gh`/local files where noted). Distinguish clearly what you VERIFIED from a source versus what is your INFERENCE, and flag anything you could not verify. Never present a guess about Bosch or India as fact.

A. Aggregation mechanics (question 1). Explain, with a concrete worked example in rupees/kW/MW, why aggregation makes small DERs meaningful: (i) minimum bid/participation sizes in real markets (find real thresholds — e.g. Germany FCR/aFRR minimums, UK, US FERC Order 2222 / PJM, and India's CERC ancillary-services or DSM/aggregator rules if any set a minimum MW — verify actual numbers); (ii) the portfolio/statistical effect — why 1,000 unreliable 5 kW sources give a more predictable block than one (explain simply, e.g. availability of any one vehicle is uncertain but the pool's expected availability is stable; the aggregator commits below the expected total to keep reliability high); (iii) how orchestration actually works technically: forecasting, baselining, dispatch signals to devices, and the real control protocols involved (OpenADR, IEEE 2030.5, OCPP smart charging, ISO 15118-20 — say which layer each plays; keep it plain); (iv) what "orchestration" means versus "aggregation" versus "VPP" versus "demand response" — a short, correct glossary; (v) 2–3 real, named, current operating examples of aggregators/VPPs (e.g. Next Kraftwerke, Octopus/Kraken, Tesla, The Mobility House, Nuvve — verify sizes/claims), stating their real scale.

B. Bosch's V2G level (question 2). Find PUBLIC, sourced information only: Bosch products, partnerships, pilots or announcements on bidirectional charging/V2G/V2X/energy management/charging communication (Bosch Mobility, Bosch Global Software Technologies, Bosch eBike/home energy, Bosch Power Tools not relevant). Include anything about Bosch's Vehicle Charge Communication Unit and ISO 15118-20, any named V2G pilot or OEM partner, and any Bosch India activity. State plainly where public information ends: say "no public evidence found" rather than guessing, and note that the user's own team (a Bosch department, "Vehicle Systems Engineering and Cloud Solutions") may know more than any public source shows.

C. India status and gaps (question 3). Verify what actually exists today: Ministry of Power EV charging guidelines (does the 2024 version mention V2G/bidirectional?), CEA/BIS standards relevant to bidirectional charging, CERC rules on aggregators / demand response / ancillary services (real names and what they permit), any real V2G or VPP pilots in India (named, with who/where/when), DISCOM demand-response programs, smart-meter rollout status (RDSS), time-of-day tariffs. Then list concrete gaps (regulatory, metering, standards, market access for small DERs, vehicle/charger availability, settlement) — each backed by a source or explicitly flagged as your inference.

D. Where normal aggregation/orchestration sits in DEG/IES (question 4). This one is mostly local/repo research: (i) read `ies-devkit/devkits/demand-flex/README.md` and its examples/roles (local clone at C:\Users\Sanjay\Desktop\DEG\ies-devkit\devkits\) and `devkits/p2p-enrollment`, `devkits/ev-charging`; (ii) use `gh api repos/India-Energy-Stack/ies-accelerator/contents/draft/use-cases-overview` and `.../use-cases-overview` (live repo — the local clone is stale) plus the IES Strategy Document v0.4 material in C:\Users\Sanjay\Desktop\DEG\research\ if useful, to identify which official IES use case (if any) covers DER aggregation / flexibility / demand response / DER visibility and what each actually covers. Answer plainly: is aggregated flexibility already an existing use case/devkit in DEG/IES (name it, and what roles/messages it defines, e.g. who is BAP/BPP, how a "flex request" and measured delivery settle), and what specifically is missing that V2G-as-aggregated-fleet would add. Be precise; quote file names.

Final output: a single relay-ready answer (plain language, clear headers A–D matching the above, worked examples, a short "what this means for our project / what to propose" closing, and a Sources list with links). Aim for thorough but readable — roughly 1,800–2,600 words. Put "verified" vs "inference" markers where it matters.
```

---

## Part 2 — The agent's final report (verbatim)

**Task:** research how aggregation works, Bosch's public V2G level, India's status and gaps, and where aggregation sits in DEG/IES. Nothing was written to disk. "Verified" means I read the source; "inference" is my reasoning; "reported" means the fact came from a search summary or secondary article.

## Correction to what I told you earlier
I said no public DEG/IES example of an aggregator exists. That was too strong. DEG's `demand-flex` devkit already has an aggregator role with enrolled meters and EV chargers, and its settlement has a shortfall penalty (details in D). So V2G looks like an **extension** of an existing use case, not a wholly new one. I also said penalties for non-delivery were missing; that is true of our P2P demo, but not of `demand-flex`.

## A. How small resources become a large supply

**1. Real minimum sizes.**
- **Germany (verified):** "For all balancing services, the minimum bid volume and bid increment is 1 MW" (Amprion). This covers FCR, aFRR and mFRR.
- **India (verified):** CERC's Ancillary Services Regulations 2022 require a reserve provider to "provide minimum response of 1 MW". The Commission kept this ([SOR §5.37](https://cercind.gov.in/Regulations/SOR-167.pdf)).
- **India, other conditions (draft text):** a two-way link to the grid control centre, metering and SCADA telemetry, response within 30 seconds, the full amount within 15 minutes, and staying on for 30 minutes.
- **India, aggregation:** the Commission says demand response may come "on its own or through an aggregator". It also says "Indian power sector does not have experience of using such resources as reserve services as of now."
- **US (reported; FERC's page returned a 403):** Order 2222 caps the minimum aggregation size an RTO may require at 100 kW. PJM's model allows aggregations of 100 kW to 5 MW, with a reported 2028 start.

**In plain terms, 1 MW is 200 cars at 5 kW.** One 1 kW home is 0.1% of the ticket, and the fixed costs (metering, contracts, settlement) don't shrink for a small unit (inference).

**2. Why a pool is more predictable than one car.** This is my calculation, not from a source. Assume 1,000 EVs at 5 kW, each plugged in and eligible 60% of evenings, independently.
- One car is available only 60% of the time, so its promise is unreliable.
- The pool's expected supply is 600 cars, or 3.0 MW, with a spread of only about 15 cars (77 kW).
- The aggregator can commit **2.82 MW with 99% confidence** and **2.76 MW with 99.9%**, keeping a safety margin below the expected 3.0 MW.
- To be 99% sure of a 1 MW bid, it needs about **370 enrolled cars**, not 200.
- Real fleets aren't independent (many unplug at the same hour), so a real aggregator would commit less.

**3. How orchestration works.** The steps are: driver consent, then forecast availability and battery level, then build an offer below the expected total, then set a baseline (what the car would have used anyway), then send dispatch signals, then measure, then settle. Which protocol does which job (reported, from OCA, CharIN and vendor summaries):
- **OpenADR:** utility or market to aggregator signalling.
- **IEEE 2030.5:** aggregator or utility to individual devices.
- **OCPP 2.1 (January 2025):** charger to operator's software, now with bidirectional and DER-control blocks.
- **ISO 15118-20:** car to charger, including bidirectional power transfer.
- **Beckn/DEG:** the marketplace and contract layer above these.

India's 2024 guidelines list "UEI, OCPP, OCPI or open ADR" as recommended protocols (Cl. 12.3, verified).

**4. Glossary.**
- **Demand response:** paying users to change usage.
- **Aggregation:** pooling many small resources into one bid.
- **Orchestration:** the live software control of that pool.
- **VPP:** the pool run as one power plant.
- **V2G:** the case where the resources are EVs that export power.

**5. Real operators (verified figures, mostly not V2G).**
- **Next Kraftwerke:** passed 10,000 MW in April 2022, with "more than 13,000 decentralized plants" (its own press release). A newer 15.5 GW figure is from a secondary article and unverified.
- **Kraken (Octopus):** "over 36 GW across 130,000 green energy assets in 12 countries" (press release, 23 January 2024).
- **The Mobility House:** "trades over 4,500 electric car batteries with more than 100MW capacity" in European markets (July 2024).
- **Nuvve:** 28.3 MW under management in FY2025, from a secondary source and unverified.

## B. Bosch's public V2G level
**Verified:**
- The Bosch Vehicle Charge Communication Unit supports CCS, GB/T, CHAdeMO and ChaoJi. Bosch lists "Plug & Charge (ISO 15118) and bidirectional power transfer according to ISO 15118-20" as software functions, and "vehicle to grid" as an optional feature ([Bosch Mobility](https://www.bosch-mobility.com/en/solutions/control-units/vehicle-charge-communication-unit/)).
- Bosch Research says its energy-management work optimizes bidirectional charging and lets batteries "feed stored energy into the electricity grid if necessary". That is a general research statement, not a product.
- Bosch's India electrification page lists power electronics, e-machines, batteries and eAxles, and does not mention V2G.

**No public evidence found** of a named Bosch V2G pilot, an OEM partner, a Bosch aggregator service, or Bosch India V2G activity. The India V2G demo below doesn't mention Bosch.

**My inference:** publicly, Bosch is at the *enabling* level, supplying vehicle-side communication hardware and software (with ISO 15118-20 as an option) plus research. It is not shown as a market operator or aggregator. Your own department may know more than any public source shows.

## C. India today, and what's missing
**What exists**
- **2024 EV charging guidelines** (verified, via a secondary copy quoting clause numbers):
  - Cl. 4 defines V2G and UEI.
  - Cl. 18 says V2G "may be enabled as per the requirements of respective Distribution Licensee".
  - The V2G tariff is "as determined by the appropriate Electricity Regulatory Commission".
  - Charge point operators may "facilitate bi-directional flow" and do smart charging "in consultation with aggregators/distribution licensee".
- **CERC 2022 Regulations:** the reserve-market rules above.
- **Rajasthan (RERC) Demand Flexibility Regulations 2026 (reported, notified April 2026):**
  - Discoms must hold flexible demand equal to 0.25% of peak in FY27, rising to 2% by FY30.
  - Third-party aggregators are recognised, and EV charging is explicitly included.
  - There is an incentive of ₹0.20 crore per MW above target, with equal penalties later.
  - The draft required registering aggregators with the Discom; I couldn't confirm the final wording.
- **First V2G demo, May 2026 (verified):**
  - ISGF led it, with BSES Rajdhani, BSES Yamuna, TPDDL and ANERT (Kerala), and technical support from the University of Delaware.
  - It used four Tata Nexon EVs **retrofitted** with bidirectional modules on AC chargers. No performance numbers were published ([release](https://www.prnewswire.com/in/news-releases/south-asias-first-ever-vehicle-to-grid-v2g-demonstration-led-by-isgf-in-collaboration-with-its-technology-and-utility-partners-302774406.html)).
  - ISGF says it is "working with local technology companies and EV OEMs to build a V2G ecosystem".
- **Smart meters (verified):** 7.24 crore installed as of 30 June 2026, of which 5.73 crore are under RDSS (Minister of State for Power's written reply). The scheme has reportedly slipped behind its 25 crore target, and its end date is reported as 31 March 2028.
- **ToD tariffs (reported):** mandatory for commercial and industrial users of 10 kW and above from April 2024, and for most others by April 2025. Peak rates are at least 1.2× for commercial and industrial users (1.1× for others). Solar-hour rates are at least 20% lower.

**Gaps.** Each is my inference from the sources above unless marked.
1. **No V2G export price.** The guidelines defer it to regulators, and I found no national tariff.
2. **Small DERs can't reach the reserve market alone.** Access needs 1 MW, grid-centre telemetry and fast response, and CERC admits no experience.
3. **Aggregator rules are state-by-state.** Rajasthan has them; I found no national aggregator framework.
4. **Metering.** Baselines need interval data, and the rollout is behind schedule (reported).
5. **Vehicles.** The demo needed retrofitted cars, which suggests bidirectional-capable EVs aren't yet on sale in India.
6. **Standards.** I could not verify a BIS or CEA standard for grid export by bidirectional chargers.

## D. Where aggregation sits in DEG/IES
**The official IES use-case list** (live repo, checked today): Consumer Energy Passport, Consumer Meter Digest, DER Visibility, P2P Energy Trading and Smart Meter Data Exchange, with drafts for DISCOM Regulatory Filing and Tariff Intelligence. **Nothing is named demand flexibility, aggregation or V2G.**

The nearest IES items:
- **DER Visibility:** a DISCOM's view of the resources behind its meters, with "any aggregator enrolling controllable resources" as a stakeholder. It is visibility only, not orchestration.
- **"DR programme rules":** a *draft* sub-use-case in the Policy as Code overview.

**Normal aggregation already exists in DEG's `devkits/demand-flex`** (`README.md`, uc1 `bdr-w-baselining`, uc2 `bid-curve-pac`):
- **Roles:** TPDDL (utility) is the BPP and publishes the need. GreenFlex (aggregator) is the BAP; it discovers the need, commits capacity per slot, and enrols meters with EV chargers behind them.
- **Example numbers:** 150 kW at ₹3.5/kWh and 200 kW at ₹4.0/kWh, with a ₹1.5 shortfall penalty. The example settles at ₹436.25.
- **Settlement formula** (`demand-flex-contractpolicy.rego`):
  - delivered = Σ over meters of max(0, BASELINE − USAGE)
  - pay = min(delivered, offered) × hours × PRICE
  - penalty = max(0, offered − delivered) × hours × SHORTFALL_PENALTY
  - net = pay − penalty
- **Worked example (my arithmetic):** offer 200 kW for 30 minutes at ₹4.0, deliver 120 kW. Pay = 120 × 0.5 × 4.0 = ₹240; penalty = 80 × 0.5 × 1.5 = ₹60; net = ₹180.
- **Scale:** it supports paging for 10,000+ meters; the example includes a 12,000-meter cohort.
- **Telemetry:** per-vehicle telemetry (including battery level) is reconciliation-only and never feeds payment.
- **Status:** the guide is "Version 0.2 (Draft / Non-Normative)".

**Other devkits:**
- `p2p-enrollment` has consent types `DATA_COLLECTION`, `DER_CONTROL` and `CROSS_UTILITY_SHARING`. In its example, `DER_CONTROL` is `granted: false`.
- `ev-charging` covers discovery, reservation, session and billing, with no discharge.
- Schemas already mark `EV_V2G`. ElectricityCredential v1.2 says it "adds ISO 15118-20 / OCPP 2.1 BPT bidirectional capability".

**What V2G adds beyond demand-flex (inference from the files):**
1. **Direction:** settlement counts *reduced consumption*; export beyond zero net use is unspecified. I don't know whether the schema allows negative usage.
2. **Availability:** battery level and departure time must limit the *offer* before commitment, but the devkit uses battery level only for after-the-fact reconciliation.
3. **Per-driver discharge consent:** `DER_CONTROL` exists but isn't wired to this flow.
4. **Moving assets:** settlement is per meter, but a car can charge at different meters.
5. **Battery wear:** no compensation is modelled.

## What this means for our project
- **Propose "V2G fleet" as an extension of the demand-flex devkit** (a third use case: the same TPDDL-style buyer and aggregator, with an EV fleet as the resources). It would add consent from `p2p-enrollment`, a battery-level limit before commitment, and export in settlement. This is far smaller than a new use case.
- **Anchor it in reality:** India's May 2026 ISGF demo, Rajasthan's aggregator rules, and the 2024 guidelines that name UEI and V2G.
- **Bosch angle (inference):** the vehicle-side communication unit is exactly the layer this proposal assumes exists.

**Could not verify:** FERC and PJM primary text (403); Next Kraftwerke's newer totals; Nuvve's figure; the final RERC text; the official 2024 guidelines text (I used a secondary copy); any BIS or CEA bidirectional standard; the final CERC response-time wording; and the RDSS target and end date (reported only).

**Sources:** [Amprion](https://www.amprion.net/Energy-Market/Market-Platform/Control-Energy/) · [CERC Statement of Reasons](https://cercind.gov.in/Regulations/SOR-167.pdf) · [2024 EV guidelines (YoCharge)](https://yocharge.com/news/govt-issues-revised-ev-charging-guidelines-2024-for-ev-charging-stations/) · [Bosch Mobility](https://www.bosch-mobility.com/en/solutions/control-units/vehicle-charge-communication-unit/) · [Bosch Research](https://www.bosch.com/research/research-fields/electrification/research-on-electrified-mobility/) · [BGSW India](https://www.bosch-softwaretechnologies.com/en/explore-and-experience/electrification-in-india/) · [ISGF V2G demo](https://www.prnewswire.com/in/news-releases/south-asias-first-ever-vehicle-to-grid-v2g-demonstration-led-by-isgf-in-collaboration-with-its-technology-and-utility-partners-302774406.html) · [RERC rules (Saur Energy)](https://www.saurenergy.com/solar-energy-news/rajasthan-finalises-demand-flexibility-rules-sets-phased-targets-from-fy27-11748510) · [RERC draft summary](https://yellowhaze.com/rerc-drafts-demand-flexibility-regulations-2026/) · [Smart meters (T&D India)](https://www.tndindia.com/indias-smart-meter-population-at-7-24-crore-parliament/) · [Next Kraftwerke](https://www.next-kraftwerke.com/news/10000-megawatt-of-aggregated-capacity) · [Octopus/Kraken](https://octopus.energy/press/kraken-technologies-kwest-acquisition/) · [The Mobility House](https://www.energy-storage.news/the-mobility-house-bringing-second-life-optimisation-experience-to-large-scale-bess-expansion-in-germany/) · [OCPP 2.1](https://openchargealliance.org/ocpp-2-1-is-now-available/) · [IES accelerator](https://github.com/India-Energy-Stack/ies-accelerator) · Local: `ies-devkit/devkits/demand-flex/README.md`, `specification/policies/demand-flex-contractpolicy.rego`, `devkits/p2p-enrollment/`, `devkits/ev-charging/`, `specification/schema/ElectricityCredential/v1.2/README.md`
