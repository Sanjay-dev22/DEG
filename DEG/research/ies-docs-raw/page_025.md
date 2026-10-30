> For the complete documentation index, see [llms.txt](https://india-energy-stack.gitbook.io/docs/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://india-energy-stack.gitbook.io/docs/readme.md).

# Getting Started

The **India Energy Stack (IES)** is an initiative of the **Ministry of Power**, Government of India, to build unified digital rails for the power sector — a common set of open specifications that lets any two systems in the sector share verified energy data without bespoke, pair-by-pair integration. **REC** is the nodal agency and **FSR Global** is the knowledge partner.

IES works the way UPI works for payments: it holds no data of its own. Data stays in the systems that already hold it — DISCOM software, metering platforms, vendor databases — and IES specifies how those systems identify each other, find each other, and exchange data in a common, verifiable form.

***

## How IES works — Register, Discover, Exchange

Every IES interaction follows the same three steps:

* **Register** — every participant gets a verifiable digital identity (a [W3C DID](https://www.w3.org/TR/did-core/)) and a listing in a shared directory (DeDi). Done once.
* **Discover** — before an exchange, the two systems look each other up, verify each other, and agree terms over the [Beckn protocol](https://github.com/beckn/protocol-specifications-v2). No bilateral arrangement needed.
* **Exchange** — data moves over the same signed Beckn channel that Discover established, shaped by published [IES schemas](/docs/schemas/schemas-ies.md) built on open standards (e.g. DLMS/COSEM, IEEE 2030.5, OpenADR etc). Where a durable record is needed, the exchange produces a [W3C Verifiable Credential](https://www.w3.org/TR/vc-data-model/) the holder keeps — in DigiLocker, for consumers. The IES Exchange flows also support bulk data transfer using both paginated inline transfer or via supported channels like signed urls, SFTP, kafka streams etc.

The specifications cover five building blocks: **Identifiers**, **Registries**, **Exchange**, **Verifiable Credentials**, and the **Security**, **Consent**, **Machine Readable Rules** posture that runs through all of them. IES selects the right open standard for each and publishes a specification that builds on it — IES does not write new standards, and it is not a platform, a database, or a product.

## What this Documentation is

This documentation is the **technical reference** for building on IES: the schema definitions with their canonical URLs, per-use-case implementation guides with step-by-step checklists, and role-based adoption pathways. If you are here to build something, go straight to:

* [**Schemas Overview**](/docs/schemas-overview/schemas-overview.md) — what each schema is for, in plain language
* [**Schemas**](/docs/schemas/schemas-ies.md) — the developer catalog: field references, canonical URIs, versions
* **Use Case Implementation Guides** — end-to-end build instructions with checklists: [Consumer Energy Passport](/docs/use-case-implementation-guides/consumer-energy-passport.md), [Consumer Meter Digest](/docs/use-case-implementation-guides/consumer-meter-digest.md), [Smart Meter Data Exchange](/docs/use-case-implementation-guides/smart-meter-data-exchange.md), [DER Visibility](/docs/use-case-implementation-guides/der-visibility.md), [P2P Energy Transaction](/docs/use-case-implementation-guides/p2p-energy-trading.md)
* [**Pathways**](/docs/pathways/pathways.md) — where to start, by the kind of organisation you are

## Before you build

Whatever you are building, every participant completes the same three prerequisites first: **register your organisation in the DeDi directory, create your `did:web` identity, and stand up your Beckn ONIX adapter**. Each implementation guide starts its checklist from these steps, and the [**Concepts**](/docs/concepts/how-you-implement-ies.md) section walks through each one in detail.

## The full story

This reference deliberately stays lean. For a detailed understanding of IES — the concepts, the in-depth architecture, the acceleration and adoption strategy, governance, and the pilot record — read the **IES report** at **REPORT URL TO BE UPDATED**.

**Where things stand:** the specifications are published and versioned in this repository. Four pilot DISCOMs — PVVNL (Uttar Pradesh), APEPDCL (Andhra Pradesh), DGVCL (Gujarat) and Tata Power (Maharashtra) — completed a 30-day DISCOM Challenge, each building an IES adapter and demonstrating the first four use cases (DER Visibility, Consumer Energy Passport, Consumer Meter Digest, Smart Meter Data Exchange) against the specifications and the pilot sandbox.

{% hint style="info" %}
📄 **Printable version:** the deliverable subset of this reference is published as a single PDF — [**ies-report.pdf**](https://india-energy-stack.github.io/ies-accelerator/ies-report.pdf).
{% endhint %}

## Get in touch

* **IES Secretariat** — `ies.secretariat@fsrglobal.org`
* **REC (Nodal Agency)** — `ies@recindia.com`
* **Issues, discussions, contributions** — [github.com/India-Energy-Stack/ies-accelerator](https://github.com/India-Energy-Stack/ies-accelerator)

## For more information and Updates on IES

* **IES Homepage** — `ies.smartgridobservatory.org`


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation dynamically by asking a question.

Perform an HTTP GET request on the current page URL with the `ask` query parameter, and the optional `goal` query parameter:

```
GET https://india-energy-stack.gitbook.io/docs/readme.md?ask=<question>&goal=<endgoal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is optional and describes the broader end goal you are ultimately trying to accomplish on behalf of the user. GitBook uses it to tailor the answer towards what is most useful for that goal.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
