> For the complete documentation index, see [llms.txt](https://india-energy-stack.gitbook.io/docs/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://india-energy-stack.gitbook.io/docs/schemas/schemas-ies.md).

# All Schemas

> One page per schema family: the current field reference, the canonical file URLs, and every published version. Use the search box (top) to find a schema or field across all of them.

## Verifiable Credentials

W3C VC payloads — signed, durable records the holder keeps and verifies independently of any network.

<table data-view="cards"><thead><tr><th></th><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>ElectricityCredential</strong></td><td>v1.2</td><td>A W3C Verifiable Credential, issued per meter or connection by a distribution licensee, that carries the static facts of a consumer's connection and the energy resources behind the meter.</td><td><a href="/pages/6bstCNXx0uxKZpIoUj2i">/pages/6bstCNXx0uxKZpIoUj2i</a></td></tr><tr><td><strong>MeterDataCredential</strong></td><td>v0.6</td><td>A signed, tamper-evident wrapper that attests who delivered a set of smart-meter readings, and that the readings have not been altered since.</td><td><a href="/pages/v1POKuDxfbO89mq6G59k">/pages/v1POKuDxfbO89mq6G59k</a></td></tr><tr><td><strong>MeterDataRequestCredential</strong></td><td>v0.1</td><td>A W3C Verifiable Credential a data requester attaches to a Beckn request to prove it is authorised to ask for smart-meter telemetry.</td><td><a href="/pages/9fK3ruTxQlTKq2vNRWrM">/pages/9fK3ruTxQlTKq2vNRWrM</a></td></tr></tbody></table>

## Data Exchange payloads

Structured, non-credential payloads exchanged over the network or published as feeds.

<table data-view="cards"><thead><tr><th></th><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>MeterData</strong></td><td>v0.6</td><td>A lightweight, high-throughput telemetry payload for exchanging smart-meter readings, events and alarms — cheap to parse and store at Head-End-System scale, without cryptographic wrapping.</td><td><a href="/pages/y0ZuhvtvDzd107imiohW">/pages/y0ZuhvtvDzd107imiohW</a></td></tr><tr><td><strong>MeterDataRequest</strong></td><td>v0.6</td><td>The query, capability and authorisation shapes a party uses to ask for smart-meter telemetry — not the telemetry itself.</td><td><a href="/pages/SavuRRYdNHvk9tMqCVlb">/pages/SavuRRYdNHvk9tMqCVlb</a></td></tr><tr><td><strong>ArrFiling</strong></td><td>v0.5</td><td>A structured, machine-readable version of the Aggregate Revenue Requirement (ARR) filing a distribution licensee submits to its state electricity regulator.</td><td><a href="/pages/xPup7c8HzUgHb3rQcAlG">/pages/xPup7c8HzUgHb3rQcAlG</a></td></tr><tr><td><strong>OutageNotification</strong></td><td>v0.1</td><td>A machine-readable payload a distribution licensee publishes to describe one planned or unplanned electricity outage — usable both as a public outage-map feed and as a push alert to affected consumers.</td><td><a href="/pages/hpQDxWVfcMskdgJboXF4">/pages/hpQDxWVfcMskdgJboXF4</a></td></tr></tbody></table>

## External — DEG schemas IES uses

Schemas defined and published outside this repository, canonical at [schema.nfh.global](https://schema.nfh.global). Their field reference is mirrored in [External Schemas](/docs/schemas/external.md).

***

## How versions work

Every schema lives at `schemas/<Family>/v<version>/` with its own `attributes.yaml` (source of truth), compiled `schema.json`, `context.jsonld`, `vocab.jsonld`, `examples/` and a generated `README.md` field reference. A **non-breaking** change (additive, optional fields, new enum values) is absorbed by the same minor version; a **breaking** change (rename, removal, type or semantics change) is published in a new sibling version, never overwriting the old one. Old versions stay reachable — see **Versions** on each page.

To propose a new schema or a change, see the [proposal flow](https://github.com/India-Energy-Stack/ies-accelerator/blob/main/schemas/README.md#proposing-a-new-schema-or-a-change).


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation dynamically by asking a question.

Perform an HTTP GET request on the current page URL with the `ask` query parameter, and the optional `goal` query parameter:

```
GET https://india-energy-stack.gitbook.io/docs/schemas/schemas-ies.md?ask=<question>&goal=<endgoal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is optional and describes the broader end goal you are ultimately trying to accomplish on behalf of the user. GitBook uses it to tailor the answer towards what is most useful for that goal.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
