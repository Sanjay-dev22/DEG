> For the complete documentation index, see [llms.txt](https://india-energy-stack.gitbook.io/docs/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://india-energy-stack.gitbook.io/docs/schemas/meterdatarequestcredential.md).

# MeterDataRequestCredential

*A W3C Verifiable Credential a data requester attaches to a Beckn request to prove it is authorised to ask for smart-meter telemetry.*

|                    |                                                                                                                                                                           |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Canonical base** | `https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequestCredential`                                                                                 |
| **Latest version** | **v0.1**                                                                                                                                                                  |
| **Status**         | Stable — In Pilot (current: **v0.1**) · **Issued by** the requester (a DISCOM, or a third-party aggregator/TSP) · **Consumed by** the data provider (AMISP or MDM system) |
| **Category**       | Verifiable Credentials                                                                                                                                                    |
| **Used in**        | [Smart Meter Data Exchange](/docs/use-case-implementation-guides/smart-meter-data-exchange.md) (optional consent proof)                                                   |

What this schema is for, in plain language — standards basis, design rationale, open points: [MeterDataRequestCredential (Schemas Overview)](/docs/schemas-overview/schemas-overview/meter-data-request-credential.md).

## Developer resources — v0.1 (current)

| Resource                 | URL                                                                                                                                                                                                                                            | Notes                                                        |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| Field reference (README) | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequestCredential/v0.1/README.md>                                                                                                                                       | human-readable field reference for this version              |
| `attributes.yaml`        | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequestCredential/v0.1/attributes.yaml>                                                                                                                                 | OpenAPI 3.1 source of truth                                  |
| `schema.json`            | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequestCredential/v0.1/schema.json>                                                                                                                                     | compiled JSON Schema (Draft 2020-12) — validate against this |
| `context.jsonld`         | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequestCredential/v0.1/context.jsonld>                                                                                                                                  | JSON-LD context for semantic resolution                      |
| `vocab.jsonld`           | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequestCredential/v0.1/vocab.jsonld>                                                                                                                                    | RDF vocabulary with standards alignments                     |
| `examples/`              | [https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataRequestCredential/v0.1/examples](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataRequestCredential/v0.1/examples/README.md) | worked payloads                                              |

## Field reference — v0.1 (current)

*A field name in **bold** with a trailing **\*** is required; all others are optional. **Type** shows units for QuantitativeValue models. Descriptions are simplified to the plain meaning of each field — the per-version pages (see **Versions** below) carry the full text, standards basis and notes.*

**MeterDataRequestCredential**

| Field               | Type                              | Description                                                                                                         |
| ------------------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `credentialSubject` | MeterDataRequestCredentialSubject | The subject of the credential: the requesting entity and the specific MeterDataRequest they are authorised to make. |

**MeterDataRequestCredentialSubject**

| Field                     | Type        | Description                                      |
| ------------------------- | ----------- | ------------------------------------------------ |
| `id`                      | uri         | DID of the requesting entity (e.g., the DISCOM). |
| **`meterDataRequest`** \* | schema.json | The scoped, time-bounded data request.           |

## Versions

Every published version stays reachable at its canonical URL — clients pin a version explicitly. Click a version for its full field reference.

| Version                                                  | Status      | Notes                                        | Files                                                                                                                                                                                                                                                                                                                                                                                              |
| -------------------------------------------------------- | ----------- | -------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [v0.1](/docs/schemas/meterdatarequestcredential/v0.1.md) | **Current** | Initial release; wraps MeterDataRequest v0.6 | [schema.json](https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequestCredential/v0.1/schema.json) · [attributes.yaml](https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequestCredential/v0.1/attributes.yaml) · [examples](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataRequestCredential/v0.1/examples/README.md) |


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation dynamically by asking a question.

Perform an HTTP GET request on the current page URL with the `ask` query parameter, and the optional `goal` query parameter:

```
GET https://india-energy-stack.gitbook.io/docs/schemas/meterdatarequestcredential.md?ask=<question>&goal=<endgoal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is optional and describes the broader end goal you are ultimately trying to accomplish on behalf of the user. GitBook uses it to tailor the answer towards what is most useful for that goal.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
