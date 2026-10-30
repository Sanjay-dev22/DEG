> For the complete documentation index, see [llms.txt](https://india-energy-stack.gitbook.io/docs/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://india-energy-stack.gitbook.io/docs/schemas/meterdatarequest/v0.5.md).

# v0.5

> **Files** — [attributes.yaml](https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest/v0.5/attributes.yaml) · [schema.json](https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest/v0.5/schema.json) · [context.jsonld](https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest/v0.5/context.jsonld) · [vocab.jsonld](https://india-energy-stack.github.io/ies-accelerator/schemas/MeterDataRequest/v0.5/vocab.jsonld) · [examples/](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataRequest/v0.5/examples/README.md)

## MeterDataRequest Schema (v0.5)

The smart meter telemetry data defined in [MeterData (v0.6)](/docs/schemas/meterdata/v0.6.md) is complemented with the `MeterDataRequest` schema – specifying **what meters**, **what data**, and **for how long** the query or permission spans.

This directory houses the **`MeterDataRequest` (v0.5)** schema for the India Energy Stack. This schema defines structural parameters for selecting and querying smart meter telemetry and profiles.

### Schema Overview

The `MeterDataRequest` schema allows a Data Consumer (BAP) to request precise datasets from a Data Provider (BPP) by specifying query boundaries, scopes, and target profiles.

#### Fields and Definitions

1. **`resources`** (Required, array of URIs/strings):
   * List of target resource identifiers to query (e.g., meter DIDs like `did:web:ies.discom.example:meter:IN-MH-MTR-89721`, service point IDs, or customer IDs).
2. **`scope`** (Required, string enum):
   * Defines the hierarchical scope of the query relative to the target resources:
     * `ResourceOnly`: Returns data matching the exact resource only.
     * `ResourceAndChildren`: Returns data for the resource and all its sub-elements/nested devices.
     * `ChildrenOnly`: Returns data exclusively for the children/sub-elements of the target resource.
3. **`from`** (Required, string date-time):
   * ISO 8601 UTC date-time indicating the start time of the requested data window (e.g., `2026-05-18T00:00:00Z`).
4. **`duration`** (Required, string duration):
   * ISO 8601 duration string representing the length of the requested data window (e.g., `PT15M`, `P1D`, `P30D`).
5. **`maxRecordsShared`** (Optional, integer):
   * Maximum number of records that should be shared or returned in a single batch/page. Must be $\ge 1$.
6. **`includeDetails`** (Optional, array of objects):
   * List of `ProfileRequest` objects to define exactly what telemetry is needed.
   * **`profileType`**: String identifying the target profile (e.g. `CustomerProfile`, `IntervalProfile`, `DailyProfile`, `MonthlyProfile`, `BillDetails`, `InstantaneousProfile`, `EventProfile`, `AlarmProfile`).
   * **`values`**: Optional list of short codes or OBIS codes requested.
   * **`requestedMode`**: Optional `TelemetryMode` (`READING` or `USAGE`). If omitted, uses the default mode for the requested value.

***

### Examples of Usage

To avoid clutter and maintain 100% compliance audits, the usage examples for this schema are saved as standalone JSON files in the `examples/` directory:

#### 1. Embedded in a Credential (DISCOM-to-TSP Data Sharing Allowance)

* **Goal**: A DISCOM grants permission to a Third Party Service Provider (TSP) to access smart meter telemetry on behalf of a consumer, restricted to **only interval (block load survey) data** for **all child meters** under a specific feeder (`did:web:ies.discom.example:feeder:IN-MH-FDR-101`).
* **Implementation**: The credential embeds a `MeterDataRequest` object defining the allowed query boundaries.
* **Telemetry Query Profile**: [MeterDataRequest\_FeederAllowance.json](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataRequest/v0.5/examples/MeterDataRequest_FeederAllowance.json)

#### 2. Provider Capabilities (Advertised Capability Profiles)

Data providers advertise what subset of profile queries they support relative to specific electrical hierarchy nodes:

* **MDM (Meter Data Management System) Capability**: Hosts raw meter readings (Interval, Daily, Instantaneous, Event, and Alarm profiles) for all target substations and their child elements.
  * **Capability Profile**: [MeterDataRequest\_MDM\_Capability.json](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataRequest/v0.5/examples/MeterDataRequest_MDM_Capability.json)
* **Billing System Capability**: Hosts customer profile metadata and detailed invoice/prepayment records.
  * **Capability Profile**: [MeterDataRequest\_Billing\_Capability.json](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataRequest/v0.5/examples/MeterDataRequest_Billing_Capability.json)

#### 3. Requesting Data (As a Query Filter)

* **Goal**: An authorized application requests the exact telemetry dataset needed to compile a **Meter Digest Credential** for a single customer (querying the customer profile, billing details, monthly registers, and daily summaries for the last 30 days).
* **Telemetry Query Filter**: [MeterDataRequest\_DigestCredentialFilter.json](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataRequest/v0.5/examples/MeterDataRequest_DigestCredentialFilter.json)
* **Standard Query Filter**: [MeterDataRequest\_Example.json](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/MeterDataRequest/v0.5/examples/MeterDataRequest_Example.json)

***

### Build and Compilation

The JSON Schema, JSON-LD Context, and RDF Vocabulary are automatically compiled from `attributes.yaml` using our Python automation script:

```bash
# From the repository root
python scripts/generate_schema.py schemas/MeterDataRequest/v0.5
```

This compiles:

* `schema.json`: Standard JSON Schema (Draft 2020-12)
* `context.jsonld`: Linked Data context file mapping attributes to `ies:` terms
* `vocab.jsonld`: Ontological vocabulary definition file

***

### Verification and Validation

All JSON example queries located under the `examples/` directory are verified against the compiled Draft 2020-12 schema using our validator utility:

```bash
# Run validation check
python scripts/validate_schema.py schemas/MeterDataRequest/v0.5/schema.json schemas/MeterDataRequest/v0.5/examples
```

***

### Field reference

*Auto-generated from `schema.json`. A field name in **bold** with a trailing **\*** is required; all others are optional. **Type** shows units for QuantitativeValue models. Where a field is derived from a standard, its description begins with **Based on** and the standard reference (from the field's `x-standard` annotation). One table per object.*

#### MeterDataRequest

| Field              | Type                                                    | Description                                                                                             |
| ------------------ | ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| **`resources`** \* | list of uri                                             | List of resource identifiers (e.g., meter DIDs, service point IDs, or customer IDs) to query.           |
| **`scope`** \*     | `ResourceOnly` / `ResourceAndChildren` / `ChildrenOnly` | Defines the hierarchical scope of the query relative to the target resources.                           |
| **`from`** \*      | date-time                                               | ISO 8601 UTC date-time indicating the start time of the requested data window.                          |
| **`duration`** \*  | duration                                                | ISO 8601 duration string representing the length of the requested data window (e.g., PT15M, P1D, P30D). |
| `maxRecordsShared` | integer                                                 | Maximum number of records that should be shared or returned in a single batch/page.                     |
| `includeDetails`   | list of ProfileRequest                                  | List of specific profile types and the data requested within them.                                      |

#### ProfileRequest

| Field                | Type                                                                                                                                                 | Description                                                                                   |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| **`profileType`** \* | `CustomerProfile` / `IntervalProfile` / `DailyProfile` / `MonthlyProfile` / `BillDetails` / `InstantaneousProfile` / `EventProfile` / `AlarmProfile` | —                                                                                             |
| `values`             | list of text                                                                                                                                         | List of requested reading/OBIS short codes or value names.                                    |
| `requestedMode`      | `READING` / `USAGE`                                                                                                                                  | The specific mode requested for these values. Defaults to the code's default mode if omitted. |


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation dynamically by asking a question.

Perform an HTTP GET request on the current page URL with the `ask` query parameter, and the optional `goal` query parameter:

```
GET https://india-energy-stack.gitbook.io/docs/schemas/meterdatarequest/v0.5.md?ask=<question>&goal=<endgoal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is optional and describes the broader end goal you are ultimately trying to accomplish on behalf of the user. GitBook uses it to tailor the answer towards what is most useful for that goal.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
