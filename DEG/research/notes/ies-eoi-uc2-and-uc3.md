# IES EOIs — UC2 (Regulatory Data Exchange) and UC3 (Policy as Code)

Sources:
- Hub: https://recindia.nic.in/eoi-ies
- UC2: https://recindia.nic.in/ies-eoi-uc2-rde-ra
- UC3: https://recindia.nic.in/ies-eoi-uc3-policy-code
Captured: 2026-08-18

Both EOIs share identical structure, timeline, governance boilerplate, and disclaimer — differing in pilot objective and scope. Both were run alongside a third EOI ("India Energy Stack Pilot Peer to Peer Trading", linked at recindia.nic.in/ies-expression-of-interest) — all three linked from the same EOI hub page.

**⚠️ Note: both timelines below list "EOI Submission Deadline: 25 February 2026" — identical to each other, and to the general Regulatory Data Exchange EOI found earlier via web search. This means UC2 and UC3 ran on the SAME EOI cycle/timeline (not two separate rounds as previously assumed from the earlier web search alone) — confirmed by this page directly rather than search summaries.** Both are long closed as of today (August 2026).

Related videos linked from the EOI hub (Google Drive):
- "IES – Peer-to-Peer Trading Platform Demo Video"
- "IES – Peer-to-Peer Electricity Trading"
- "IES – Introductory Video"
- "IES – Energy Credential"
Press release: https://www.recindia.nic.in/uploads/files/Press-ReleasePress-Information-Bureau-IES.pdf

---

## UC2: India Energy Stack Pilot on Regulatory Data Exchange and Regulatory Analytics

**Pilot Objective**: Demonstrate end-to-end regulatory data exchange using IES specifications and sandbox infrastructure. Reference flow: dataset packaging, schema validation, provenance and versioning, controlled publication, access logging, reuse through APIs/applications in the IES sandbox.

**Scope of Participation** (propose one or more):
1. **Validation and Conformance Tooling** — schema/completeness checks, rule-based validation, provenance/versioning, auditable trace logs aligned to IES specs.
2. **Regulator or Public Interfaces** — search, compare, visualise disclosed datasets via dashboards/dataset discovery portals.
3. **Regulatory Analytics and Regulatory GPT-style Tools** — retrieval and source-linked summaries over disclosed data, benchmarking, scenarios, forecasting, evaluation — with strong traceability, citations, reproducibility, misuse safeguards.
4. **Integration Adapters** — connectors to onboard pilot partners, demonstrate end-to-end exchange in the sandbox using IES specs.

**Pilot Format**: Sandbox-driven implementation sprint, ~4 weeks from onboarding, structured technical check-ins, final demo last week of March 2026. Focus: practical prototypes, measurable demonstrations, stakeholder-tested workflows.

**What IES provides to selected participants**: defined schemas/reference specs for regulatory data exchange; sandbox environment with API access; sample datasets designated for pilot use; conformance/evaluation checklist; access to GitHub repos and technical guidance. (Referenced "IES Strategy & Architecture v0.3" — now superseded by v0.4, March 2026.)

**Why participate**: demonstrate innovation in regulatory transparency/usability/trust; showcase interoperability/conformance to power-sector stakeholders; position for future deployment as IES adoption scales (subject to applicable processes — not guaranteed).

**Who should apply**: teams with capability in data validation/quality engineering; regulatory data portals/visualisation/search platforms; applied AI/LLM systems over structured datasets with guardrails/evaluation frameworks; power-sector regulatory reporting systems and utility integration; API design/interoperability standards/DPI implementation.

**Selection considerations (indicative)**: ability to deliver stable, scalable prototypes within defined timelines; approach to auditability/traceability/responsible data use; accuracy controls and safeguards in AI-based systems (source-linked outputs, prevention of non-public data exposure); experience with power-sector/regulatory datasets; clear technical architecture and implementation plan.

**Timeline**: EOI deadline 25 Feb 2026, 6:00 PM IST → onboarding 28 Feb 2026 → prototype dev + demo last week of March 2026.

**Submission**: Microsoft Form "IES Expression of Interest – Regulatory Data Exchange" → https://forms.office.com/r/XzXfJBjpht

**Queries**: ies@recindia.com / IES.secretariat@fsrglobal.org

**Disclaimer**: REC Limited reserves the right to accept/reject any or all EOIs without assigning reason. Acceptance does not guarantee showcasing or future deployment.

---

## UC3: India Energy Stack Pilot on Policy as Code

**Pilot Objective**: Validate an end-to-end workflow to translate regulatory/utility policies into versioned, machine-executable "policy packs" and apply them consistently across participating systems. Policies in scope: tariffs, rebates, subsidies, eligibility rules, program rules, related operational logic used in billing, customer programs, settlement, reporting. Reference flow: policy digitisation → packaging into versioned policy packs → validation against schemas/test cases → controlled publication → audit logging → deterministic execution/verification in the IES sandbox.

**Scope of Participation** (propose one or more):
1. **Policy Pack Authoring and Tooling** — workflows to translate policy text into structured policy logic and generate versioned policy packs aligned to IES specs; human-led, AI-assisted, or hybrid approaches all allowed.
2. **Validation and Conformance** — schema/completeness checks, rule consistency checks, test harnesses, golden test cases, regression testing, auditable trace logs to verify policy packs and execution outputs.
3. **Execution and Integration** — connectors/adapters to integrate policy packs into pilot partner systems (billing, CIS, portals, tariff engines); demonstrate consistent application across systems.
4. **Auditability and Explainability** — traceability controls from policy pack to applied outcome: versioning, change logs, decision traces, user-facing explainability for regulators/utilities/consumers.

**Pilot Format**: Same as UC2 — ~4-week sandbox sprint, final demo last week of March 2026.

**What IES provides**: defined specs/reference schemas for Policy as Code and policy pack structure; sandbox with API access; sample policy artifacts/reference examples; conformance/evaluation checklist; GitHub access and technical guidance.

**Why participate**: demonstrate interoperability/conformance in a multi-stakeholder setting; showcase methods for policy digitisation, deterministic execution, and reduction of disputes through consistent policy application; position for future deployment (not guaranteed).

**Who should apply**: teams with power-sector enterprise systems/integration experience (billing, CIS, ERP, portals, tariff engines); rule modeling, policy digitisation workflows, test harness design; developer tooling for packaging/validation/auditability; sandbox-driven delivery and system integration with utilities/regulators.

**Selection considerations (indicative)**: ability to deliver stable, scalable prototypes within timelines; approach to trust/auditability/deterministic execution (traceability from policy pack to output); experience with power-sector policies/regulatory reporting/utility implementations; clear technical architecture, delivery plan, integration approach with pilot partners.

**Timeline**: identical to UC2 — EOI deadline 25 Feb 2026, 6:00 PM IST → onboarding 28 Feb 2026 → prototype dev + demo last week of March 2026.

**Submission**: Microsoft Form "IES Expression of Interest – Policy as Code" → https://forms.office.com/r/xJNtaMnB8d

**Queries / Disclaimer**: same as UC2.

---

## Cross-reference to the technical docs (ies.recindia.org.in/docs)

These two EOIs map almost exactly onto the two "Draft (Work in Progress)" use cases in the technical documentation:
- **UC2 (Regulatory Data Exchange)** ≈ **DISCOM Regulatory Filing** doc page — `ArrFiling v0.5` schema, DISCOM=BPP/SERC=BAP.
- **UC3 (Policy as Code)** ≈ **Policy as Code (Tariff Intelligence)** doc page — `IES_Policy` schema, SERC=BPP (publisher)/DISCOM billing systems=BAP (consumers).

The EOI's "Scope of Participation" categories map onto specific schema fields and open items already flagged as unresolved in the docs (see `ies-docs-technical-summary.md`): e.g. UC2's "Validation and Conformance Tooling" ↔ the docs' still-converging `category`/`subCategory` cost-taxonomy enum; UC3's "Policy Pack Authoring" ↔ the docs' still-draft `policyType` enum (only `TARIFF`/`DISPATCH_GUIDE` live) and unresolved amendment/versioning convention (`replaces` field not yet governed).
