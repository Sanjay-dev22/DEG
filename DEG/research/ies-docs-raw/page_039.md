> For the complete documentation index, see [llms.txt](https://india-energy-stack.gitbook.io/docs/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://india-energy-stack.gitbook.io/docs/schemas/meterdatarequest.md).

# MeterDataRequest

*The query, capability and authorisation shapes a party uses to ask for smart-meter telemetry — not the telemetry itself.*

|                    |                                                                                                                                                        |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Canonical base** | `https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest`                                                                        |
| **Latest version** | **v0.6**                                                                                                                                               |
| **Status**         | Stable — In Pilot (current: **v0.6**) · **Published by** providers (DISCOMs, AMISPs) · **Used by** requesters (DISCOMs, TSPs, consented third parties) |
| **Category**       | Data Exchange payloads                                                                                                                                 |
| **Used in**        | [Smart Meter Data Exchange](/docs/use-case-implementation-guides/smart-meter-data-exchange.md)                                                         |

What this schema is for, in plain language — standards basis, design rationale, open points: [MeterDataRequest (Schemas Overview)](/docs/schemas-overview/schemas-overview/meter-data-request.md).

## Developer resources — v0.6 (current)

| Resource                 | URL                                                                                                                                                                                                                        | Notes                                                        |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| Field reference (README) | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest/v0.6/README.md>                                                                                                                             | human-readable field reference for this version              |
| `attributes.yaml`        | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest/v0.6/attributes.yaml>                                                                                                                       | OpenAPI 3.1 source of truth                                  |
| `schema.json`            | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest/v0.6/schema.json>                                                                                                                           | compiled JSON Schema (Draft 2020-12) — validate against this |
| `context.jsonld`         | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest/v0.6/context.jsonld>                                                                                                                        | JSON-LD context for semantic resolution                      |
| `vocab.jsonld`           | <https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest/v0.6/vocab.jsonld>                                                                                                                          | RDF vocabulary with standards alignments                     |
| `examples/`              | [https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataRequest/v0.6/examples](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataRequest/v0.6/examples/README.md) | worked payloads                                              |

## Field reference — v0.6 (current)

*A field name in **bold** with a trailing **\*** is required; all others are optional. **Type** shows units for QuantitativeValue models. Descriptions are simplified to the plain meaning of each field — the per-version pages (see **Versions** below) carry the full text, standards basis and notes.*

**MeterDataRequest**

| Field                          | Type                                                    | Description                                                                                             |
| ------------------------------ | ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| `consumers`                    | list of uri                                             | List of consumer URIs/DIDs for whom the data is requested (optional).                                   |
| `resources`                    | list of uri                                             | List of resource URIs/DIDs (e.g. meter DIDs, service point IDs) to query (optional).                    |
| `scope`                        | `ResourceOnly` / `ResourceAndChildren` / `ChildrenOnly` | —                                                                                                       |
| **`from`** \*                  | date-time                                               | ISO 8601 UTC date-time indicating the start time of the requested data window.                          |
| **`duration`** \*              | duration                                                | ISO 8601 duration string representing the length of the requested data window (e.g., PT15M, P1D, P30D). |
| `consumerConsent`              | list of text                                            | Consent references/receipts proving authorization (optional).                                           |
| `authorisation`                | MeterDataAuthorisation or uri                           | Inline authorization object or URI reference to it.                                                     |
| **`capabilitiesRequested`** \* | MeterDataCapabilities                                   | —                                                                                                       |
| `maxRecordsShared`             | integer                                                 | Maximum number of records that should be shared or returned in a single batch/page.                     |

**MeterDataAuthorisation**

| Field                 | Type                  | Description                                                             |
| --------------------- | --------------------- | ----------------------------------------------------------------------- |
| **`grantor`** \*      | uri                   | URI/DID of the entity authorizing access.                               |
| **`grantee`** \*      | uri                   | URI/DID of the authorized entity.                                       |
| **`purpose`** \*      | text                  | Reason/purpose for data access.                                         |
| **`validFrom`** \*    | date-time             | ISO 8601 UTC date-time indicating when the authorization becomes valid. |
| **`validUntil`** \*   | date-time             | ISO 8601 UTC date-time indicating when the authorization expires.       |
| **`capabilities`** \* | MeterDataCapabilities | —                                                                       |

**MeterDataCapabilities**

| Field                | Type                                                            | Description                                                         |
| -------------------- | --------------------------------------------------------------- | ------------------------------------------------------------------- |
| **`profiles`** \*    | list of ProfileCapability                                       | List of profiles and their specific values/modes.                   |
| `supportedScopes`    | list of `ResourceOnly` / `ResourceAndChildren` / `ChildrenOnly` | Hierarchical scopes supported by the query processor.               |
| `maxHistoryDuration` | duration                                                        | Maximum length of historical data window supported by the provider. |

**ProfileCapability**

| Field                | Type                                                                                                                                                 | Description                                               |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| **`profileType`** \* | `CustomerProfile` / `IntervalProfile` / `DailyProfile` / `MonthlyProfile` / `BillDetails` / `InstantaneousProfile` / `EventProfile` / `AlarmProfile` | —                                                         |
| `readings`           | list of ValueCapability                                                                                                                              | Granular capabilities for specific registers and metrics. |

**ValueCapability**

| Field          | Type                | Description                                                                                |
| -------------- | ------------------- | ------------------------------------------------------------------------------------------ |
| **`value`** \* | text                | The OBIS code (e.g. 1.0.1.8.0.255) or short code (e.g. kWh imp) representing the register. |
| `mode`         | `READING` / `USAGE` | The telemetry mode (READING, USAGE) supported or requested for this register.              |
| `multiplier`   | number              | Optional decimal multiplier scaling factor (e.g., 0.001 or 1000).                          |
| `accuracy`     | number              | Optional accuracy class or precision value.                                                |

## Versions

Every published version stays reachable at its canonical URL — clients pin a version explicitly. Click a version for its full field reference.

| Version                                        | Status      | Notes                                                                                               | Files                                                                                                                                                                                                                                                                                                                                                                |
| ---------------------------------------------- | ----------- | --------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [v0.6](/docs/schemas/meterdatarequest/v0.6.md) | **Current** | Split into three composable models: MeterDataCapabilities, MeterDataAuthorisation, MeterDataRequest | [schema.json](https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest/v0.6/schema.json) · [attributes.yaml](https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest/v0.6/attributes.yaml) · [examples](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataRequest/v0.6/examples/README.md) |
| [v0.5](/docs/schemas/meterdatarequest/v0.5.md) | Previous    | Single unified request schema                                                                       | [schema.json](https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest/v0.5/schema.json) · [attributes.yaml](https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest/v0.5/attributes.yaml) · [examples](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataRequest/v0.5/examples/README.md) |


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation dynamically by asking a question.

Perform an HTTP GET request on the current page URL with the `ask` query parameter, and the optional `goal` query parameter:

```
GET https://india-energy-stack.gitbook.io/docs/schemas/meterdatarequest.md?ask=<question>&goal=<endgoal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is optional and describes the broader end goal you are ultimately trying to accomplish on behalf of the user. GitBook uses it to tailor the answer towards what is most useful for that goal.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
