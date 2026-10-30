> For the complete documentation index, see [llms.txt](https://india-energy-stack.gitbook.io/docs/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://india-energy-stack.gitbook.io/docs/concepts/security.md).

# Security Model

*How IES treats security: as a first-class design concern, layered on top of the power sector's existing operational-security standards, with software-layer guarantees — signed services, verifiable endpoints, cryptographic agility — that the specifications require of every participant.*

This page states the security posture of the IES specifications in three parts. Detailed, testable requirements live with the building blocks they secure — [Register](/docs/concepts/setup-register/register.md), [Discover](/docs/concepts/setup-exchange/discover.md), [Exchange](/docs/concepts/setup-exchange/exchange.md) and [Verifiable Credentials](/docs/concepts/issue-credentials/energy-credentials.md) — and in the schema definitions themselves.

***

## 1. Security is a first-class citizen

Security in IES is not a hardening step applied after the fact; it is built into the architecture's core primitives. Every participant's identity is a cryptographic identity (a W3C DID) before it is anything else. Every interaction between participants — a discovery call, a data exchange, a credential issued to a consumer — is signed by construction, so every message is attributable to a registered, verifiable actor. There is no anonymous or unauthenticated path through the stack: the same Register → Discover → Exchange sequence that makes data flow possible is also what makes each flow authenticated, authorised and auditable.

## 2. IES builds on the sector's existing security — it does not replace it

The power sector already operates under established operational- and device-level security regimes: **IEC 62351** (security for power-system communication protocols), **IEC 62443** (security for industrial automation and control systems), the **DLMS/COSEM security suites** protecting meter communications, and the **CEA cyber-security guidelines** that regulate Indian power-sector IT and OT systems. IES does not reimplement, weaken or bypass any of these.

IES operates one layer above: at the point where structured data, already produced inside a utility's secured perimeter, is shared with another organisation or with a consumer. A DISCOM's HES/MDM chain, SCADA systems and meter fleet keep their existing protections; the IES adapter sits at the utility's edge and adds interoperable, verifiable exchange on top of them. Sector security standards govern how data is produced and held; IES governs how it is shared.

## 3. What IES adds at the software layer

On top of the sector's existing controls, the IES specifications bring the security techniques of modern digital public infrastructure to every exchange:

* **Every service is signed.** There are no unsigned APIs in IES. Beckn-protocol messages carry participant signatures, and credentials carry W3C proofs — a receiver can always verify who sent a payload and that it was not altered in transit.
* **Every endpoint is verifiable.** A participant's `did:web` identity and its DeDi directory entry let any counterparty resolve, and cryptographically check, who it is talking to before any data moves — trust is established by lookup and verification, not by bilateral arrangement.
* **Verifiability travels with the data.** A verifiable credential can be checked by a bank, a marketplace or a regulator that has never met the issuer, because the proof is inside the artifact itself rather than dependent on a trusted channel.
* **Cryptographic agility.** Signature suites and key material are referenced indirectly (through DID documents and proof metadata), not hard-coded, so algorithms can be rotated and upgraded — including migration to post-quantum schemes as standards mature — without redesigning the stack.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation dynamically by asking a question.

Perform an HTTP GET request on the current page URL with the `ask` query parameter, and the optional `goal` query parameter:

```
GET https://india-energy-stack.gitbook.io/docs/concepts/security.md?ask=<question>&goal=<endgoal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is optional and describes the broader end goal you are ultimately trying to accomplish on behalf of the user. GitBook uses it to tailor the answer towards what is most useful for that goal.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
