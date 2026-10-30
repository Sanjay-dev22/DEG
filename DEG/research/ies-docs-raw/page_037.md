> For the complete documentation index, see [llms.txt](https://india-energy-stack.gitbook.io/docs/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://india-energy-stack.gitbook.io/docs/schemas/meterdatacredential.md).

# MeterDataCredential

*A signed, tamper-evident wrapper that attests who delivered a set of smart-meter readings, and that the readings have not been altered since.*

|                    |                                                                                                                                                                                                                           |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Canonical base** | `https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataCredential`                                                                                                                                        |
| **Latest version** | **v0.6**                                                                                                                                                                                                                  |
| **Status**         | Stable — In Pilot (current: **v0.6**, aligned with MeterData v0.6) · **Issued by** data providers (AMISPs, MDM systems, or a DISCOM in that role) · **Consumed by** DISCOMs, consumers' wallets, and downstream verifiers |
| **Category**       | Verifiable Credentials                                                                                                                                                                                                    |
| **Used in**        | [Consumer Meter Digest](/docs/use-case-implementation-guides/consumer-meter-digest.md)                                                                                                                                    |

What this schema is for, in plain language — standards basis, design rationale, open points: [MeterDataCredential (Schemas Overview)](/docs/schemas-overview/schemas-overview/meter-data-credential.md).

## Developer resources — v0.6 (current)

| Resource                 | URL                                                                                                                                                                                                                              | Notes                                                        |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| Field reference (README) | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataCredential/v0.6/README.md>                                                                                                                                | human-readable field reference for this version              |
| `attributes.yaml`        | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataCredential/v0.6/attributes.yaml>                                                                                                                          | OpenAPI 3.1 source of truth                                  |
| `schema.json`            | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataCredential/v0.6/schema.json>                                                                                                                              | compiled JSON Schema (Draft 2020-12) — validate against this |
| `context.jsonld`         | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataCredential/v0.6/context.jsonld>                                                                                                                           | JSON-LD context for semantic resolution                      |
| `vocab.jsonld`           | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataCredential/v0.6/vocab.jsonld>                                                                                                                             | RDF vocabulary with standards alignments                     |
| `examples/`              | [https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataCredential/v0.6/examples](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataCredential/v0.6/examples/README.md) | worked payloads                                              |

## Field reference — v0.6 (current)

*A field name in **bold** with a trailing **\*** is required; all others are optional. **Type** shows units for QuantitativeValue models. Descriptions are simplified to the plain meaning of each field — the per-version pages (see **Versions** below) carry the full text, standards basis and notes.*

**MeterDataCredential**

| Field               | Type                       | Description                                                                                                           |
| ------------------- | -------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `credentialSubject` | MeterDataCredentialSubject | The subject of the credential: the consumer or asset entity whose meter data is attested, plus the MeterData payload. |

**MeterDataCredentialSubject**

| Field              | Type        | Description                                                              |
| ------------------ | ----------- | ------------------------------------------------------------------------ |
| `id`               | uri         | DID of the consumer or asset entity whose meter data is being delivered. |
| **`meterData`** \* | schema.json | The attested meter data payload.                                         |

## Versions

Every published version stays reachable at its canonical URL — clients pin a version explicitly. Click a version for its full field reference.

| Version                                           | Status      | Notes                                                                                  | Files                                                                                                                                                                                                                                                                                                                                                                         |
| ------------------------------------------------- | ----------- | -------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [v0.6](/docs/schemas/meterdatacredential/v0.6.md) | **Current** | Wraps MeterData v0.6; DeDi-registry revocation (`credentialStatus.type: dediregistry`) | [schema.json](https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataCredential/v0.6/schema.json) · [attributes.yaml](https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataCredential/v0.6/attributes.yaml) · [examples](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataCredential/v0.6/examples/README.md) |


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation dynamically by asking a question.

Perform an HTTP GET request on the current page URL with the `ask` query parameter, and the optional `goal` query parameter:

```
GET https://india-energy-stack.gitbook.io/docs/schemas/meterdatacredential.md?ask=<question>&goal=<endgoal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is optional and describes the broader end goal you are ultimately trying to accomplish on behalf of the user. GitBook uses it to tailor the answer towards what is most useful for that goal.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
