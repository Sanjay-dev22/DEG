> For the complete documentation index, see [llms.txt](https://india-energy-stack.gitbook.io/docs/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://india-energy-stack.gitbook.io/docs/concepts/setup-exchange/discover.md).

# Discover in depth

> **The second of the three IES steps — Register, Discover, Exchange.** Interaction protocol. Before every exchange, both systems look each other up, confirm the other is genuine, and agree on what will be exchanged and on what terms. *No bilateral arrangement is needed.*

Once participants are [Registered](/docs/concepts/setup-register/register.md) (Step 1), they need a way to **find each other, negotiate terms, and produce a signed audit trail** of what was agreed — without anyone phoning anyone. IES uses the open [**Beckn Protocol v2**](https://github.com/beckn/protocol-specifications-v2) for this — and the same signed Beckn channel then carries the [Exchange](/docs/concepts/setup-exchange/exchange.md) payloads, so Beckn is the rail for both steps, with Discover as its look-up-and-contract stage.

Discover belongs to the **data exchange** capability — B2B exchange of structured datasets between registered organisations. The other IES capability, [**Verifiable Credentials**](/docs/concepts/issue-credentials/energy-credentials.md), does not need this step: a credential is issued and verified against the issuer's published key, with no Beckn network involved.

***

## Two rails, two kinds of trust

|                       | **B2B data exchange** (this page + [Exchange](/docs/concepts/setup-exchange/exchange.md))                                                                                                                                                                                         | **B2C credentials** ([Issuing Credentials](/docs/concepts/issue-credentials.md))                                                                                                                                                |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **What moves**        | Structured datasets — meter telemetry, regulatory filings, tariff data, trade offers                                                                                                                                                                                              | Signed attestations — a consumer's connection record, a meter digest                                                                                                                                                            |
| **Between whom**      | Two **registered organisations** that know who they are transacting with                                                                                                                                                                                                          | An issuer and **any third party** — a bank, a marketplace, a housing society — that the issuer has never met                                                                                                                    |
| **Trust layer**       | **Bilateral, anchored in DeDi.** Each side resolves the other's subscriber record, verifies its message signature, and checks that both belong to the same curated network. The network operator (NFO) maintains that membership boundary.                                        | **Unilateral, anchored in `did:web`.** The issuer signs once; any verifier, anywhere, fetches the issuer's published key over HTTPS and checks the signature — no membership, no prior relationship, no callback to the issuer. |
| **Channel**           | Must ride a **trust-bounded open network** — IES uses [Beckn Protocol v2](https://github.com/beckn/protocol-specifications-v2) — because discovery, negotiation, consent and the signed audit trail are part of the exchange itself                                               | **Any channel** — DigiLocker, a web portal, email, SMS, chat. The trust travels inside the credential, not the pipe.                                                                                                            |
| **Typical use cases** | [Smart Meter Data Exchange](/docs/use-case-implementation-guides/smart-meter-data-exchange.md), [Regulatory Filing](/docs/draft-work-in-progress/discom-regulatory-filing/discom-regulatory-filing.md), [P2P Trading](/docs/use-case-implementation-guides/p2p-energy-trading.md) | [Consumer Energy Passport](/docs/use-case-implementation-guides/consumer-energy-passport.md), [Consumer Meter Digest](/docs/use-case-implementation-guides/consumer-meter-digest.md)                                            |

The rest of this page covers how the B2B rail's two registered parties find each other, agree terms, and sign — the *Discover* step. What they actually exchange once agreed — the schemas and, where needed, verifiable credentials — is *Exchange*, covered on its own page.

***

## Find, agree, and sign without a pre-negotiated integration

Energy data in India moves through bespoke point-to-point channels today — PDF filings, vendor-locked exports, one-off API integrations. A bespoke REST API per counterparty is exactly the n×m problem IES is solving. (Note: the *trust* here is still bilateral — each side verifies the other — but the wiring is not; you build to the protocol once, not to each partner.) Beckn is a single, open, **asynchronous and peer-to-peer** interaction protocol that any party builds to once and uses against every counterparty:

| Concern             | What Beckn provides                                                                                                                 |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Discovery           | Either party can publish a catalogue of what it offers (datasets, credentials, dispatch programmes) and other parties can query it. |
| Negotiation         | A standard `select` / `init` round-trip lets the two sides agree on quantity, price, SLA, delivery method.                          |
| Commitment          | A signed `confirm` / `on_confirm` round-trip **is the contract**. The signed envelope is the non-repudiable record of agreement.    |
| Status and delivery | `status` / `on_status` carry asynchronous fulfilment — including payload delivery, pagination, settlement updates.                  |
| Consent and audit   | Every message is signed; every leg leaves a tamper-evident receipt.                                                                 |

There is no central broker: the network operator curates the membership list, but every message flows directly between participants. The wire and the lifecycle are the same whether the payload is meter telemetry, a regulatory filing, a tariff order, or a peer-to-peer energy trade.

### The lifecycle at a glance

| Phase           | BAP — the consumer side (Beckn Application Platform) calls | BPP — the provider side (Beckn Provider Platform) responds | When you need it                                            |
| --------------- | ---------------------------------------------------------- | ---------------------------------------------------------- | ----------------------------------------------------------- |
| Discovery       | `discover`                                                 | `on_discover`                                              | Consumer doesn't yet know which provider to contract with   |
| Negotiation     | `select` / `init`                                          | `on_select` / `on_init`                                    | Terms need agreeing before commitment                       |
| Commitment      | `confirm`                                                  | `on_confirm`                                               | **The minimal flow** — payload can be delivered inline here |
| Delivery        | `status`                                                   | `on_status`                                                | Payload prepared asynchronously, or paged across messages   |
| Post-fulfilment | `update`                                                   | `on_update`                                                | Amendments, credential rotation                             |

**Minimal viable exchange:** `confirm` → `on_confirm`, with the dataset embedded in the callback. Everything else is optional; each use-case implementation guide lists which actions it actually exercises. Small datasets ride **inline** in the message (the IES default — end-to-end verifiable); large ones hand off to an established channel (signed URL, MQTT, Kafka, SFTP) agreed inside the same contract, so every exchange gets the same signed-audit story. Wire-level detail — message envelope, correlation rules, pagination, `accessMethod` values — is in the [Setting up Discover & Exchange appendices](/docs/concepts/setup-exchange.md#appendices).

## The IES networks

IES currently operates three Beckn networks (each with a `test-` twin for onboarding and certification) under the `indiaenergystack.in` namespace: **data sharing**, **P2P trading**, and **DER integration**. Membership is per-network and per-environment; the adapter rejects messages from outside the configured boundary. The registry mechanics are in [Register — The directory: DeDi](/docs/concepts/setup-register/register.md#the-directory-dedi); how to get listed is [Setting up Register §1.7](https://india-energy-stack.gitbook.io/docs/concepts/setup-exchange/pages/x4JXc2x9ljke9mGdzMbp#id-1.7-beckn-participants-get-referenced-into-an-ies-network).

***

## What you set up under Discover

For an IES participant, Discover means registering on Beckn and becoming findable — before anyone can exchange anything with you, they need to be able to look you up and verify who you are:

1. **Beckn signing keypair** — an Ed25519 keypair used to sign and verify messages (separate from the EC P-256 keypair used for credentials).
2. **Beckn subscriber record** — a small entry in your DeDi namespace declaring your callback URL, role (`BAP` / `BPP`), and Ed25519 message-signing public key. Other Beckn nodes look this up to verify your signatures.
3. **Network reference** — the IES network operator (acting as Network Facilitator Organisation, NFO) writes a *reference* into the network registry pointing at your subscriber record. This is the membership boundary.

These three are covered by [**Setting up Register §1.5–1.7**](https://india-energy-stack.gitbook.io/docs/concepts/setup-exchange/pages/x4JXc2x9ljke9mGdzMbp#id-1.5-beckn-participants-generate-your-beckn-signing-keypair). Standing up the adapter that actually runs an exchange against this registration — ONIX, the sandbox walkthrough, wire mechanics — is [**Setting up Discover & Exchange**](/docs/concepts/setup-exchange.md).

***

## Where this fits

| Step                                                           | Page                                                             |
| -------------------------------------------------------------- | ---------------------------------------------------------------- |
| Step 1 — [Register](/docs/concepts/setup-register/register.md) | Identity + directory                                             |
| Step 2 — Discover *(this page)*                                | —                                                                |
| Step 3 — [Exchange](/docs/concepts/setup-exchange/exchange.md) | Signed Beckn payload delivery — schemas + verifiable credentials |

To register on Beckn hands-on: [**Setting up Register §1.5–1.7**](/docs/concepts/setup-register.md). To run the adapter and exchange data: [**Setting up Discover & Exchange**](/docs/concepts/setup-exchange.md).


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation dynamically by asking a question.

Perform an HTTP GET request on the current page URL with the `ask` query parameter, and the optional `goal` query parameter:

```
GET https://india-energy-stack.gitbook.io/docs/concepts/setup-exchange/discover.md?ask=<question>&goal=<endgoal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is optional and describes the broader end goal you are ultimately trying to accomplish on behalf of the user. GitBook uses it to tailor the answer towards what is most useful for that goal.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
