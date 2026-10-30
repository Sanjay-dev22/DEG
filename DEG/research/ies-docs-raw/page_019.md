> For the complete documentation index, see [llms.txt](https://india-energy-stack.gitbook.io/docs/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://india-energy-stack.gitbook.io/docs/pathways/pathways.md).

# Overview

A **Pathway** answers one question: *"I am a particular kind of organisation — what do I do, in what order, and where are the docs for each step?"* IES combines several standards (DIDs, DeDi registries, W3C Verifiable Credentials, the Beckn protocol), and adopting them touches IT, commercial, and operational teams at once. Each pathway sequences that work for one role, so you follow a roadmap instead of parsing raw specifications.

## Available Pathways

| Pathway                                                          | Who is it for?                                                                  | What it covers                                                                                                                                                                                       |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [**Utility Pathway**](/docs/pathways/utility.md)                 | Electricity distribution utilities                                              | Identity and registries, issuing Energy Passports, Smart Meter Data Exchange, verifiable bills, DER visibility, ARR publication.                                                                     |
| [**Secretariat Pathway**](/docs/pathways/secretariat.md)         | IES Secretariat and network operators                                           | Registry setup, verifying and whitelisting participants, Beckn network governance, schema publication and migration.                                                                                 |
| [**Authority / Regulator Pathway**](/docs/pathways/authority.md) | Ministry of Power, CEA, CERC/SERC, Forum of Regulators, State Governments / UTs | Registering a regulator identity, receiving DISCOM ARR filings machine-readably, publishing tariff orders as policy-as-code, IES Cell governance duties.                                             |
| [**Technology Service Provider Pathway**](/docs/pathways/tsp.md) | AMISPs, meter/EV-charger/inverter OEMs, system integrators, analytics vendors   | Building the DISCOM-specific adapter mapping, mapping product data into MeterData or ElectricityCredential, registering a distinct multi-DISCOM identity, conformance-testing once per product line. |
| [**Researcher / Analyst Pathway**](/docs/pathways/researcher.md) | Academics, think-tanks, policy researchers, journalists, students               | Read-only: orienting on Register/Discover/Exchange, exploring schemas and examples, reproducing validation and pilot outcomes, contributing a schema proposal.                                       |

## How to use a pathway

* Each pathway is divided into phases; technical detail sits in collapsible panels (`<details>`) — scan the roadmap, expand a step when you're ready to act on it.
* Inline prework checklists tell you what to line up with your IT, commercial, and legal teams before each phase.
* Every step links to the reference page — schema, registry, or setup guide — that carries the full specification.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation dynamically by asking a question.

Perform an HTTP GET request on the current page URL with the `ask` query parameter, and the optional `goal` query parameter:

```
GET https://india-energy-stack.gitbook.io/docs/pathways/pathways.md?ask=<question>&goal=<endgoal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is optional and describes the broader end goal you are ultimately trying to accomplish on behalf of the user. GitBook uses it to tailor the answer towards what is most useful for that goal.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
