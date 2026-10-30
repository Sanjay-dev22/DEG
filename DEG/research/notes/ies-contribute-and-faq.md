# IES — Contribute to IES + FAQ (recindia.nic.in)

Sources: https://recindia.nic.in/contribute-to-ies and https://recindia.nic.in/faq-ies (Hindi; translated below)
Captured: 2026-08-18

## Contribute to IES — schema/taxonomy contribution pathway

This is a **separate, governance-oriented contribution path** — distinct from the TSP building pathway in the technical docs. It's for shaping the shared vocabulary itself, not for building a product on top of it.

**Who can contribute**: Distribution utilities, generation companies & renewable developers, transmission entities, Grid India/SLDC/RLDC, regulators & policy institutions, AMISPs/MDM providers/technology service providers, market participants/aggregators/innovators, academic/research/standards bodies.

**Why schema/taxonomy contributions matter**: They reduce repeated point-to-point integration, make energy data machine-readable and reusable, improve interoperability between entities/regulators/service providers, enable trustworthy exchange via verifiable credentials and digital signatures, support faster innovation, and create a common language adoptable sector-wide.

**Example given**: a "taxonomy" defines reusable vocabulary (e.g. asset types — Meter, Generator [SOLAR_PV/WIND/HYDRO/BIOGAS/CHP/FUEL_CELL], Storage [BESS], EV Charger [EV_CHARGER/EV_V2G], Inverter, Load [SMART_HVAC/SMART_WATER_HEATER/CONTROLLABLE_LOAD], Network [DT/BUS/FEEDER/MICROGRID]) — while a "schema" is the use-case-specific structure that embeds/references that taxonomy without redefining it. E.g. a BESS asset (`id`, `type: BESS`) is referenced identically across ElectricityCredential, a DemandFlexBuyOffer, and a P2P EnergyTradeOffer — "defined once in the taxonomy, reused many times in schemas."

**5-step contribution process**:
1. Identify the use case
2. Define the data requirement
3. Map to existing IES schemas as much as possible, to enable reusability
4. Reuse standard IES taxonomy wherever possible, or contribute to enriching the taxonomy
5. Submit the proposal for review

**6-step post-submission review process**:
1. Acknowledgement
2. Review by the central IES team
3. Community consultation and collaborative refinement
4. Publication
5. Ecosystem adoption
6. Continued engagement

**Submission entry point**: https://ies.recindia.org.in/docs/propose-a-schema
**Demo video**: https://www.recindia.nic.in/uploads/output_final_new.mp4

---

## FAQ — IES (20 Q&As, full translation)

1. **Does IES replace existing systems?** No. IES stores, operates, or controls no data or system. Every system an organization currently runs keeps working. IES only standardizes the *method* of sharing data with other organizations' systems.

2. **Is IES only for connecting to other organizations, or also useful internally?** Primarily for connecting an organization's systems to other organizations' systems, where the most friction exists today. But the same adapters/standards also help internally where multiple vendors' systems can't exchange data with each other. The big win is external (between DISCOMs and states); internal improvement follows automatically.

3. **Will IES create new compliance work?** No. IES does not require any new data. It only arranges already-produced data into a common format at the time of sharing.

4. **If a metering system was integrated recently, is that work wasted?** No. Previously completed work doesn't need to be redone. IES sets a common standard that future integrations will follow, making the *next* integration easier.

5. **Where does the data go?** Nowhere new. Data stays at its point of origin. IES only standardizes the method by which data is described and requested when moving between organizations.

6. **Is IES something you buy and install?** No. IES is a set of free, published specifications. No license fee, no central platform to install. A pre-built connector (adapter) is provided to get started.

7. **Who builds the connector?** The connector (adapter) is mostly pre-built. IES provides it as free software based on the Beckn ONIX reference implementation, with a working sample. An organization's technology vendor configures it for their systems and adds the mapping between their data format and IES's format. Vendors build to one published standard instead of doing fresh custom integration each time.

8. **Does IES change anything about regulator relationships?** No. IES only converts existing CEA and CERC rules into a software-readable format. If implementing a rule reveals a discrepancy, IES surfaces it to the regulator — but the regulator alone decides what happens next.

9. **How is consumer private data protected?** A consumer can attest to a single fact without disclosing the rest of the data — e.g., that sanctioned load exceeds a specified threshold, without revealing the exact value.

10. **Is IES live, or still just on paper?** It is live. The sandbox is actively running, and four pilot DISCOMs are currently building on it.

11. **Some work could already be done within a single DISCOM — why is IES needed then?** Some kinds of work (like shifting demand within a single area) can already be done independently today. But IES is built for the entire country, and benefits every participant, not just others. A consumer arriving from another state brings an energy record that can be trusted immediately without new verification. Any bank or scheme anywhere in India can accept a record issued by a DISCOM, giving consumers faster service. A service or vendor certified in one state becomes available in other states without rebuilding. Working separately, every DISCOM solves the same problem itself; with a common standard, the work happens once and every participant can use it.

12. **What does the consumer get?** A portable, verifiable record of their connection with the DISCOM — including sanctioned load, any approved generation, and their own consumption history — kept safe in DigiLocker. The consumer can share it on their own terms to get a green loan, claim a subsidy, or register for a service, without repeated visits to the DISCOM for paperwork. Portable, verifiable records also help the utility serve its customer base better: faster enrollment, fewer repeated verifications, and new services built on consent-based data.

13. **Is IES also relevant for an organization whose main goal is improving existing systems rather than building new ones?** Yes. The same one-time adapter does both jobs — it improves data exchange between current systems, and provides the foundation for adding new services on the same standard later. There's no need to choose between improving existing systems and building new ones.

14. **If a new service or new type of device is added later, does the process restart from scratch?** No. Each asset (like a meter, solar unit, or EV charger) gets its digital identity at the moment it's first needed for a practical use case — not all at once on day one. Everything already available — verified identity, trust checks, approved data formats — gets reused. The first asset takes the most effort to onboard; every subsequent asset is much simpler.

15. **Does IES meet cybersecurity requirements set for the power sector?** Yes. IES is being designed for compliance with applicable power-sector cybersecurity regulations. Every message carries a digital signature, and identity, consent, and data layers are kept separate. The adapter is installed only at the system's outer edge and creates no new internal integration points. Cybersecurity incidents are handled per the power sector's established incident-response process. IES mainly provides a secure link for data exchange between parties using non-safety-critical data, without requiring all data to pass through any central chokepoint.

16. **Does IES protect personal data?** Yes. IES does not store personal data. Consumer-related data is shared only with the consumer's explicit consent and only for the stated purpose. IES is being designed for compliance with applicable data protection law.

17. **What commercial benefit does a DISCOM get from IES?** Three points, in simple terms. First, lower cost: one published standard replaces repeated pairwise system integration, cutting technology procurement and integration expense, and removing dependence on a single vendor. Second, better operations: reliable, verifiable data becomes the basis for demand forecasting and analysis, improving the timing of power purchases and reducing losses. Third, wider use of existing data: with consumer consent, verified records can enable services like green lending and rooftop solar financing — and demand for these records ultimately flows back through the DISCOM. IES is not a revenue-generation scheme and does not monetize personal data. It reduces cost and increases the utility of data DISCOMs already hold.

18. **Does IES support large-scale/bulk data transfer?** Yes, with no size limit. IES specifies data format and coordination, not transport — so data always moves through an organization's normal channels, like secure web connections or file transfer. Two options exist: (1) Inline — data is sent in small batches inside IES-formatted messages themselves; (2) By link — data stays as a file, and the IES message carries a signed link to retrieve it. Either way, IES manages discovery, consent, and audit trail; no separate "bulk" feature is needed.

19. **Who adds or updates specifications and standards?** This is the role of the **IES Cell**, a governing body being constituted under the Central Electricity Authority with sector-wide representation. It owns the specifications, decides what gets added or changed, and publishes each version. Its detailed governance framework will be notified separately.

20. **What is the process to request a modification or change to a published specification?** Any participant can submit a proposed modification to the IES Cell. Proposals are reviewed, and approved changes are published as a new, versioned specification — so every implementation knows exactly what changed and when. This detailed process will be defined once the IES Cell's governance framework is notified.

---

## Notable points for our purposes

- **FAQ #10 confirms**: IES sandbox is live now, with 4 pilot DISCOMs actively building (matches the main-page "DISCOM Challenge" details).
- **FAQ #19 reveals new governance detail not seen elsewhere**: specification ownership sits with an **"IES Cell"** — a governing body being constituted under the **Central Electricity Authority (CEA)** with sector-wide representation. This is more formal/statutory than "REC as nodal agency" alone — suggests specification governance is being institutionalized under a central regulator, not just run informally by REC/FSR Global.
- **FAQ #6/#7 reinforce**: no cost to participate, no product to buy — the only real "build" work is the adapter mapping, consistent with the TSP Pathway docs.
- **FAQ #3/#4 reinforce**: nothing about IES requires new data collection or invalidates recent integration work — lowers the objection bar for a TSP pitching this to a skeptical DISCOM client.
