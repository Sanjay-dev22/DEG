> For the complete documentation index, see [llms.txt](https://india-energy-stack.gitbook.io/docs/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://india-energy-stack.gitbook.io/docs/schemas-overview/schemas-overview.md).

# Schemas Overview

Before the field-by-field technical reference, each IES schema gets one plain-language page here — what it is, who issues it, what standards it follows, and where it still has open questions. This is the same **IES Documentation Template** already used for every use-case guide (sections 1–7 in plain language, a condensed Schedule I/II, Annexures A–C), applied to the schema itself rather than to a use case built on top of it.

Read one of these before the field reference in [Schemas](/docs/schemas/schemas-ies.md) if you want the *why* before the *what*.

| Schema                                                                                                          | What it is                                                                                                                                            | Status               |
| --------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------- |
| [**ElectricityCredential v1.2**](/docs/schemas-overview/schemas-overview/electricity-credential.md)             | W3C Verifiable Credential — a consumer connection's static facts and the energy resources behind the meter                                            | Stable — In Pilot    |
| [**MeterData v0.6**](/docs/schemas-overview/schemas-overview/meter-data.md)                                     | Compact telemetry payload — nine record shapes (eight telemetry profiles plus a shared descriptor object) for smart-meter readings, events and alarms | Stable — In Pilot    |
| [**MeterDataCredential v0.6**](/docs/schemas-overview/schemas-overview/meter-data-credential.md)                | W3C Verifiable Credential wrapping a MeterData payload to attest its provenance                                                                       | Stable — In Pilot    |
| [**MeterDataRequest v0.6**](/docs/schemas-overview/schemas-overview/meter-data-request.md)                      | Query and authorisation payload for asking a provider for telemetry                                                                                   | Stable — In Pilot    |
| [**MeterDataRequestCredential v0.1**](/docs/schemas-overview/schemas-overview/meter-data-request-credential.md) | W3C Verifiable Credential wrapping a MeterDataRequest to prove the requester's authorisation                                                          | Stable — In Pilot    |
| [**ArrFiling v0.5**](/docs/schemas-overview/schemas-overview/arr-filing.md)                                     | Structured Aggregate Revenue Requirement filing — DISCOM to SERC                                                                                      | **Work in progress** |
| [**OutageNotification v0.1**](/docs/schemas-overview/schemas-overview/outage-notification.md)                   | Planned/unplanned outage record — pull feed + CAP-aligned push                                                                                        | **Work in progress** |

The full field-level reference for each of these families lives in the [**Schemas**](/docs/schemas/schemas-ies.md) section (directly below this one in the navigation), which also carries the canonical URLs of the machine-readable files (`schema.json`, `context.jsonld`, examples).

***

## Where the P2P and flexibility schemas live (external)

Some IES use cases build on schemas that IES does **not** publish itself — they are maintained upstream in the **Digital Energy Grid (DEG)** project, canonical at [schema.nfh.global](https://schema.nfh.global). If you are looking for the schemas behind [**P2P Energy Transaction**](/docs/use-case-implementation-guides/p2p-energy-trading.md) (`P2PTrade`, `DEGContract`, `EnergyTradeOffer`, …) or demand-side flexibility (`DemandFlexNeed`, `DemandFlexBuyOffer`, …), you will not find them among the families above — they are mirrored, with a field reference, in [**External Schemas**](/docs/schemas/external.md) under the [Schemas](/docs/schemas/schemas-ies.md) section. The pages above cover only the schema families IES itself stewards.

***

## How each page is organised

Every page follows the same eleven numbered sections as a use-case guide, minus the use-case-specific extras:

1. **Scope and Purpose** — the problem, in plain words
2. **What It Records / Covers** — what is captured
3. **How Each Item is Identified** — DIDs, identifier patterns
4. **Definitions** — terms and acronyms
5. **Basis of Standards** — the standards this schema follows (BIS → CEA → IEC → IEEE precedence)
6. **Where Indian Standards Do Not Yet Exist** — gaps and the international standards used
7. **The Record(s)** — what the schema actually produces
8. **Schedule I — Field Reference (summary)** — block names, linking to the full auto-generated table
9. **Schedule II** — whether this schema wraps or depends on another
10. **How It Fits Together** — how this schema relates to others and to use cases
11. **Points for Confirmation** — genuinely open questions

* **Annexure A — Standards Referenced**, **Annexure B — Example Payloads**, **Annexure C — JSON Schema** (all linking back to the schema's own files rather than duplicating them)

***

## Where this fits

This section sits directly above the [**Schemas**](/docs/schemas/schemas-ies.md) developer catalog in the navigation — the field references and canonical file URLs these pages introduce. The Exchange building block these schemas travel over is covered in [**Exchange in depth**](/docs/concepts/setup-exchange/exchange.md) under Concepts.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation dynamically by asking a question.

Perform an HTTP GET request on the current page URL with the `ask` query parameter, and the optional `goal` query parameter:

```
GET https://india-energy-stack.gitbook.io/docs/schemas-overview/schemas-overview.md?ask=<question>&goal=<endgoal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is optional and describes the broader end goal you are ultimately trying to accomplish on behalf of the user. GitBook uses it to tailor the answer towards what is most useful for that goal.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
