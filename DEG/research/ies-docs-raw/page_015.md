> For the complete documentation index, see [llms.txt](https://india-energy-stack.gitbook.io/docs/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://india-energy-stack.gitbook.io/docs/draft-work-in-progress/draft.md).

# About this section

> 🚧 **Everything under this section is a draft.** These pages were not finalised during the IES Task Force period. They are preserved here so the work is not lost and a future phase can pick them up, but they are **not part of the IES deliverable**, are excluded from the published PDF, and should not be relied on: names, fields, flows and conclusions are all subject to change.

## Contents

| Page                                                                                                                                       | What it is                                                                     |
| ------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------ |
| [DISCOM Regulatory Filing (WIP) — Overview](/docs/draft-work-in-progress/discom-regulatory-filing.md)                                      | Draft use-case overview: structured ARR/tariff filings from DISCOMs to SERCs.  |
| [Policy as Code (WIP) — Overview](/docs/draft-work-in-progress/tariff-intelligence.md)                                                     | Draft use-case overview: tariff and policy published as machine-readable code. |
| [DISCOM Regulatory Filing (WIP) — Implementation Guide](/docs/draft-work-in-progress/discom-regulatory-filing/discom-regulatory-filing.md) | Draft developer build for the filing use case.                                 |
| [Policy as Code (WIP) — Implementation Guide](/docs/draft-work-in-progress/tariff-intelligence/tariff-intelligence.md)                     | Draft developer build for the policy-as-code use case.                         |

The [ArrFiling schema family](/docs/schemas/arrfiling.md) referenced by the filing use case remains published under `schemas/` at **Work in progress** status.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation dynamically by asking a question.

Perform an HTTP GET request on the current page URL with the `ask` query parameter, and the optional `goal` query parameter:

```
GET https://india-energy-stack.gitbook.io/docs/draft-work-in-progress/draft.md?ask=<question>&goal=<endgoal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is optional and describes the broader end goal you are ultimately trying to accomplish on behalf of the user. GitBook uses it to tailor the answer towards what is most useful for that goal.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
