> For the complete documentation index, see [llms.txt](https://india-energy-stack.gitbook.io/docs/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://india-energy-stack.gitbook.io/docs/schemas/arrfiling/v0.5.md).

# v0.5

> **Files** — [attributes.yaml](https://india-energy-stack.github.io/ies-accelerator/schemas/ArrFiling/v0.5/attributes.yaml) · [schema.json](https://india-energy-stack.github.io/ies-accelerator/schemas/ArrFiling/v0.5/schema.json) · [context.jsonld](https://india-energy-stack.github.io/ies-accelerator/schemas/ArrFiling/v0.5/context.jsonld) · [vocab.jsonld](https://india-energy-stack.github.io/ies-accelerator/schemas/ArrFiling/v0.5/vocab.jsonld) · [examples/](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/ArrFiling/v0.5/examples/README.md)

## Aggregate Revenue Requirement (ARR) Filing Schema (v0.5)

This directory contains the **Aggregate Revenue Requirement (ARR) Filing** (v0.5) schema definitions and semantic models for utility regulatory data exchange. It is designed to standardize the structure of ARR filings made by distribution licensees (DISCOMs) to State Electricity Regulatory Commissions (SERCs) in India.

### Overview

The `ArrFiling` schema unifies diverse state-level regulatory filing formats by structuring them into three relational classes:

1. **`ArrFiling` (Root)** — Describes global metadata about a filing, including filing ID, licensee/DISCOM details, receiving regulatory commission, control period, currency, and unit scale.
2. **`ArrFiscalYear`** — Connects a specific fiscal year to its baseline/control-period classification and amount basis (e.g., Audited actuals, SERC-Approved values, or proposed projections).
3. **`ArrLineItem`** — Represents a single cost, revenue, subtotal, or true-up adjustment line item matching the regulatory sub-forms (e.g. Power Purchase Cost, O\&M Expenses, Net ARR).

***

### Directory Structure and Files

| File                                                                                                                        | Description                                                                                   |
| --------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| [`attributes.yaml`](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/ArrFiling/v0.5/attributes.yaml) | Canonical OpenAPI 3.1.0 schema source of truth, describing all attributes, models, and types. |
| [`schema.json`](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/ArrFiling/v0.5/schema.json)         | Compiled Draft 2020-12 JSON Schema for standard validation of data payloads.                  |
| [`context.jsonld`](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/ArrFiling/v0.5/context.jsonld)   | Compiled JSON-LD context mapping ARR attributes to semantic terms under the `ies:` prefix.    |
| [`vocab.jsonld`](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/ArrFiling/v0.5/vocab.jsonld)       | Compiled JSON-LD vocabulary ontology graph defining classes and properties.                   |
| [`examples/`](https://github.com/India-Energy-Stack/ies-accelerator/tree/main/schemas/ArrFiling/v0.5/examples/README.md)    | JSON-LD absolute-linked regulatory example files.                                             |

***

### Schema Generation and Compilation

The JSON Schema and JSON-LD context/vocabulary are compiled automatically from the core `attributes.yaml` using our generic Python build script.

#### To Compile Schemas

To recompile schemas following modifications in `attributes.yaml`, run the following command from the repository root:

```bash
python scripts/generate_schema.py schemas/ArrFiling/v0.5
```

***

### Payload Verification & Validation

Example JSON files are validated for structural compliance against `schema.json` using our dedicated validation script.

#### To Validate Example Payloads

Run the following command from the repository root:

```bash
python scripts/validate_schema.py schemas/ArrFiling/v0.5/schema.json schemas/ArrFiling/v0.5/examples
```

***

### JSON-LD Integration

All example payloads in the `examples/` directory have been augmented to support standard Linked Data semantic resolution:

1. **`@context`** — Points to the canonical absolute URL `https://india-energy-stack.github.io/ies-accelerator/schemas/ArrFiling/v0.5/context.jsonld` to resolve terms.
2. **`@type`** — Indicates the profile class shape (e.g., `ArrFiling`), aligning the regulatory datasets to the broader India Energy Stack ecosystem.

***

### Field reference

*Auto-generated from `schema.json`. A field name in **bold** with a trailing **\*** is required; all others are optional. **Type** shows units for QuantitativeValue models. Where a field is derived from a standard, its description begins with **Based on** and the standard reference (from the field's `x-standard` annotation). One table per object.*

#### ArrFiling

| Field                         | Type                                                             | Description                                                                                                                                                                                                                                                        |
| ----------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **`objectType`** \*           | `ARR_FILING`                                                     | —                                                                                                                                                                                                                                                                  |
| `id`                          | text                                                             | Unique identifier for this filing.                                                                                                                                                                                                                                 |
| **`filingId`** \*             | text                                                             | Regulatory filing reference number.                                                                                                                                                                                                                                |
| `filingDate`                  | date                                                             | —                                                                                                                                                                                                                                                                  |
| `filingType`                  | `MYT` / `ANNUAL` / `TRUE_UP` / `REVISED`                         | MYT - Multi-Year Tariff control period filing (multiple years, mix of actual/proposed) ANNUAL - single year or historical year-by-year approved data TRUE\_UP - reconciliation of actuals vs previously approved amounts REVISED - amended filing with corrections |
| **`licensee`** \*             | text                                                             | Full name of the distribution licensee.                                                                                                                                                                                                                            |
| `licenseeCode`                | text                                                             | Short code for the licensee.                                                                                                                                                                                                                                       |
| `stateProvince`               | text                                                             | —                                                                                                                                                                                                                                                                  |
| **`regulatoryCommission`** \* | text                                                             | SERC or Joint ERC that receives the filing.                                                                                                                                                                                                                        |
| `controlPeriodStart`          | text                                                             | Start fiscal year of MYT control period (only for MYT filings).                                                                                                                                                                                                    |
| `controlPeriodEnd`            | text                                                             | End fiscal year of MYT control period.                                                                                                                                                                                                                             |
| **`currency`** \*             | `INR`                                                            | —                                                                                                                                                                                                                                                                  |
| **`unitScale`** \*            | `CRORE` / `LAKH` / `ABSOLUTE`                                    | Scale of all amounts in the filing.                                                                                                                                                                                                                                |
| `status`                      | `DRAFT` / `SUBMITTED` / `UNDER_REVIEW` / `APPROVED` / `REJECTED` | —                                                                                                                                                                                                                                                                  |
| `formReference`               | text                                                             | Regulatory form identifier.                                                                                                                                                                                                                                        |
| `notes`                       | list of text                                                     | Footnotes, regulatory order references, and explanatory notes.                                                                                                                                                                                                     |
| **`fiscalYears`** \*          | list of ArrFiscalYear                                            | —                                                                                                                                                                                                                                                                  |

#### ArrFiscalYear

| Field                | Type                                                           | Description                                                                                                                                                                                                                                                                                               |
| -------------------- | -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`fiscalYear`** \*  | text                                                           | Fiscal year label.                                                                                                                                                                                                                                                                                        |
| `yearType`           | `BASE_YEAR` / `CONTROL_PERIOD` / `HISTORICAL`                  | BASE\_YEAR - reference year in an MYT filing (typically the year before the control period) CONTROL\_PERIOD - a year within the MYT control period being filed for HISTORICAL - a past year with finalized data (used in annual/historical filings)                                                       |
| **`amountBasis`** \* | `AUDITED` / `APPROVED` / `PROPOSED` / `TRUED_UP` / `NOT_FILED` | AUDITED - actual costs verified by auditors APPROVED - amounts approved by the SERC in a tariff order PROPOSED - amounts requested by the DISCOM, pending SERC approval TRUED\_UP - reconciled amounts after comparing actuals to approved NOT\_FILED - placeholder year in a control period, no data yet |
| **`lineItems`** \*   | list of ArrLineItem                                            | —                                                                                                                                                                                                                                                                                                         |

#### ArrLineItem

| Field               | Type                                                                                                                                                                                      | Description                                                                                                                                                                                                                                                                                                                                                                        |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`lineItemId`** \* | text                                                                                                                                                                                      | Stable identifier for this line item across years. Use kebab-case, e.g., "power-purchase-cost", "interest-working-cap".                                                                                                                                                                                                                                                            |
| `serialNumber`      | integer                                                                                                                                                                                   | Display order as shown in the regulatory form.                                                                                                                                                                                                                                                                                                                                     |
| **`category`** \*   | `VARIABLE` / `FIXED` / `INCOME` / `SUB_TOTAL` / `ARR` / `ADJUSTMENT`                                                                                                                      | VARIABLE - costs varying with energy volume (power purchase) FIXED - costs independent of volume (O\&M, depreciation, interest, return) INCOME - revenue credits that reduce the ARR (negative amounts) SUB\_TOTAL - computed aggregation of other line items ARR - the final net/aggregate revenue requirement ADJUSTMENT - true-up corrections, pass-throughs, FPPCA adjustments |
| `subCategory`       | `POWER_PURCHASE` / `NETWORK_COST` / `O_AND_M` / `DEPRECIATION` / `INTEREST` / `RETURN_ON_EQUITY` / `PROVISIONAL` / `OTHER` / `NON_TARIFF_INCOME` / `REVENUE_CREDIT` / `TOTAL` / `NET_ARR` | Functional sub-classification for analysis and comparison across DISCOMs.                                                                                                                                                                                                                                                                                                          |
| **`head`** \*       | text                                                                                                                                                                                      | Short heading as used in the regulatory form. Varies by DISCOM — use the original text from the filing.                                                                                                                                                                                                                                                                            |
| `particulars`       | text                                                                                                                                                                                      | Detailed description or the "Particulars" column value. Useful when head alone is ambiguous (e.g., "Others" head with "Incentive/Disincentive on achievement of norms" as particulars).                                                                                                                                                                                            |
| **`amount`** \*     | number / null                                                                                                                                                                             | Amount in the filing's currency and unitScale. Null means the line item exists in the form but was not filed / not applicable. Negative values represent credits, deductions, or adjustments that reduce ARR.                                                                                                                                                                      |
| `formReference`     | text                                                                                                                                                                                      | Reference to the supporting sub-form or schedule.                                                                                                                                                                                                                                                                                                                                  |
| `componentOf`       | text                                                                                                                                                                                      | lineItemId of the parent subtotal this item contributes to.                                                                                                                                                                                                                                                                                                                        |
| `formula`           | text                                                                                                                                                                                      | Human-readable computation formula expressed as references to other lineItemIds. Only present on SUB\_TOTAL and ARR items.                                                                                                                                                                                                                                                         |


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation dynamically by asking a question.

Perform an HTTP GET request on the current page URL with the `ask` query parameter, and the optional `goal` query parameter:

```
GET https://india-energy-stack.gitbook.io/docs/schemas/arrfiling/v0.5.md?ask=<question>&goal=<endgoal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is optional and describes the broader end goal you are ultimately trying to accomplish on behalf of the user. GitBook uses it to tailor the answer towards what is most useful for that goal.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
