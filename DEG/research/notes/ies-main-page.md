# India Energy Stack — Main Page (recindia.nic.in/india-energy-stack)

Source: https://recindia.nic.in/india-energy-stack (page in Hindi; translated/summarized below)
Captured: 2026-08-18

## Governance
- **Chief Patron**: Shri Nandan Nilekani
- **Nodal Agency**: REC Limited
- **Knowledge Partner**: FSR Global
- Sponsoring ministry: Ministry of Power, Government of India

## IES: Why, What, How (numbered points from page)

1. **The problem**: Indian power-sector entities have built many consumer-level digital tools — smart meters, rooftop solar, EV charging, demand-side metering. Each generates useful data, but it stays trapped inside separate systems: the DISCOM's own software, the metering agency's portal (run by an AMISP — Advanced Metering Infrastructure Service Provider), and each vendor's database — all in formats other systems can't read. Every time two systems need to share data, a new manual connection has to be built from scratch. Rules are still issued and verified on paper. Consumers can't use their own consumption data. India has invested in digital tools but not in a shared, integrated way for these tools to coordinate with each other.

2. **The cost**: This fragmentation has a real financial cost borne by the whole power sector. A single DISCOM often runs metering systems from multiple vendors and takes years to interconnect them, because none was built to a shared standard. System operators, regulators, and technology providers face the same difficulty — and the same effort gets repeated nationwide.

3. **What IES is**: A shared set of specifications for sharing data across the power sector — functioning the way UPI functions for banking. UPI holds no money itself; money stays in the customer's bank, and UPI is just a shared rulebook letting any bank's app pay any other bank's customer without a separate bilateral arrangement. IES does the same for energy data instead of money. Data stays in the systems where it already lives; IES specs ensure any system can exchange data with any other system without a separate bilateral arrangement per pair. Rules already exist for what data to report and how to structure it — IES doesn't replace any of them. It makes that same data machine-readable, uniform across the sector, and verifiable, so any two systems can exchange data directly and act on it quickly.

4. **What IES is NOT**:
   - A central platform or database that stores energy data
   - A replacement for any existing DISCOM system, meter-data-management system, or consumer-information system
   - A new regulator or authority that sets energy rules
   - A software product that organizations buy and install
   - A system that controls or monitors the physical grid

5. **How it works — 3 steps**:
   - **Registration (verifiable digital identity)**: Every participant gets a digital identity and is listed in a shared directory. Done once. Uses **W3C Decentralized Identifiers (DIDs)**.
   - **Discovery (interaction protocol)**: Before every transaction, both systems verify each other — confirming authenticity and agreeing what data will be exchanged and under what terms. No separate bilateral arrangement needed between any two parties. Uses **Beckn Protocol**.
   - **Exchange (schema, classification, and verifiable credentials)**: Data moves using agreed field names/structure, following the public standard for that domain — e.g. **DLMS/COSEM for meter data, IEEE 2030.5 for solar & storage, OpenADR for demand response**. Where a durable record is needed, the exchange also produces a **verifiable credential** — e.g. Consumer Energy Passport, Consumer Meter Digest, DER commissioning record. The holder keeps it in **DigiLocker** and can share it with any bank, regulator, or scheme administrator without going back to the issuer.

   IES picks the appropriate open standard for each step and issues a specification based on it — IES does not invent new standards. Once a system is built to conform to IES specs one time, it can connect directly to any other IES-enabled system with no further integration work.

6. **The Adapter concept**: No changes are made to an organization's internal systems. A small piece of software called an **"Adapter"** sits at each system's edge to ensure IES-conformant operation. It has two parts:
   - **Part 1 (generic, pre-built, same for everyone)**: handles discovering other systems and exchanging messages. This is the **"Beckn Onix"** reference software — participants do NOT need to build this themselves.
   - **Part 2 (custom per organization)**: a small mapping layer that translates between the org's own data formats and IES specifications. Built once; after that, the org's databases, field names, and internal software stay exactly as they were. Once built, any new IES-enabled partner connects directly without further integration work.

7. **What becomes possible once IES is used**:
   - **For consumers**: Energy history becomes portable and verifiable — usable for green loans, subsidy claims, or service registrations without contacting the DISCOM or paperwork. DISCOM-issued certificates are directly usable by banks, housing finance companies, scheme administrators, and service providers needing verified energy data. Demand for these credentials directly benefits DISCOMs.
   - **For the grid**: Every distributed energy resource (e.g. rooftop solar unit, small battery) gets a verified identity the first time it connects. Grid operators get reliable visibility into these resources; connections between DISCOMs, AMISPs, and aggregators (companies that pool many small resources) become possible without a separate arrangement per pair.
   - **For regulators**: Filings arrive already signed, in a uniform, consistent format. Tariff orders become computable. Regulators can monitor data directly instead of reading PDF documents.
   - **For markets**: Demand-side flexibility, peer-to-peer energy exchange (consumers buying/selling power directly), and open access (a large consumer buying power from a supplier other than the local DISCOM) become practically viable, without a separate agreement needed between every pair of participants.

8. **What IES has already changed** (practical outcomes of the specs):
   - **Integration cost drops**: a published standard replaces custom point-to-point work; adding a new system takes days rather than months.
   - **No vendor lock-in**: IES conformance gets built into procurement specifications, so vendors build to a published standard rather than entities being tied to one supplier.
   - **Each new capability costs less than the last**: identity and trust infrastructure gets reused, so DER, flexibility, and market use cases build on what's already established.
   - **New services become viable**: banks, financial institutions, and aggregators can build new services on top of verified energy data — similar to how the "Account Aggregator" framework enabled new lenders in finance. This creates demand for data that directly benefits DISCOMs.
   - **Existing data becomes more useful**: once energy data is verifiable and in a shared format, it can be used for power-purchase/demand forecasting, loss-reduction and load-management analytics, and as the basis for consent-based services like green loans — the same data DISCOMs already have, now usable beyond the system that created it.

## ⭐ CRITICAL: Live pilot already completed (NOT mentioned in the March 2026 v0.4 Strategy Document)

> IES is already running in a live sandbox/test environment. Specifications are published on the **IES GitBook**, and the sandbox is operational.

**A 30-day challenge ran 21 May – 21 June 2026** with **four pilot DISCOMs across four states**, each of which built its own IES Adapter and successfully demonstrated a first set of live use cases:

1. **PVVNL** (Pashchimanchal Vidyut Vitran Nigam Limited) — Meerut, Uttar Pradesh
2. **APEDCL** (Eastern Power Distribution Company of Andhra Pradesh) — Visakhapatnam, Andhra Pradesh
3. **DGVCL** (Dakshin Gujarat Vij Company Limited) — Surat, Gujarat
4. **Tata Power** — Mumbai, Maharashtra

### Four use cases demonstrated (results table)

| Use Case | What was demonstrated | With IES | Before IES |
|---|---|---|---|
| **DER Visibility** | Solar unit registered with verified digital identity; grid operator confirmed visibility of it | ✔ | No reliable sector-wide method existed |
| **Consumer Energy Passport** | Energy passport issued and stored in DigiLocker; consumer able to share it for green loan, subsidy claim, or service enrollment | ✔ | Not previously possible: no portable, verifiable consumer energy record existed |
| **Consumer Meter Digest** | Verifiable record of consumption history, reusable across DISCOMs/states without re-verification | ✔ | Manual and confined to a single DISCOM; not reusable elsewhere |
| **Smart Meter Data Exchange** | IES-conformant data exchange completed between DISCOM and AMISP without a bilateral integration agreement | ✔ | Bilateral integration could take weeks to months per pair |

**⚠️ This directly changes our use-case gap analysis**: Consumer Energy Passport (my earlier top recommendation) and what looks like "My Energy Digest" (here called "Consumer Meter Digest") have ALREADY been piloted and demonstrated by real DISCOMs, alongside DER Visibility. Only a subset of the 8 use cases from the v0.4 doc remain genuinely untouched by any known pilot/EOI — need to re-derive the open list (see parent synthesis).

## Call for participation

All state governments, UT administrations, and every power-sector entity are invited to participate — including distribution utilities, GENCOs, TRANSCOs, State Load Despatch Centres, the National Load Despatch Centre, central/state electricity regulatory commissions and the Forum of Regulators, metering agencies (AMISPs), equipment manufacturers (including EV and metering OEMs), technology/analytics providers, aggregators, and financial institutions that use verified energy data.

**Minimum participation criteria (same for every organization type)**:
1. Create a digital identity and list the organization in the shared directory
2. Build an IES Adapter
3. Pass a basic conformance check

After that, any new participant connects directly with no further integration work required.

## Navigation structure of the IES section (Hindi labels → English → URL)
- हमारे बारे में (About us) → this page → https://recindia.nic.in/india-energy-stack
- टास्क फोर्स (Task Force) → task-force-ies
- आईईएस विनिर्देश (IES Specifications) → https://ies.recindia.org.in/docs
- ईओआई और अन्य रिपॉज़िटरी (EOIs and other repository) → eoi-ies
- उदाहरणात्मक यूज़ केस (Illustrative Use Cases) → illustrative-use-cases
- आईईएस में योगदान करें (Contribute to IES) → contribute-to-ies
- एफएक्यू (FAQ) → faq-ies
