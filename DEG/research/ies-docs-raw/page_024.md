> For the complete documentation index, see [llms.txt](https://india-energy-stack.gitbook.io/docs/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://india-energy-stack.gitbook.io/docs/propose-a-schema.md).

# Propose a Schema

The IES ecosystem grows through community-proposed schemas. If you're working on a data model that a use case needs, propose it here — tell us who you are, which use case it supports, the schema itself, and the standards it builds on.

Fill in the form below. Your contact details (email and mobile) are kept **private** — shared only with the IES secretariat. A public tracking issue is created automatically for the proposal itself (schema, use case, standards) so the community can review and discuss it. No GitHub account is required to submit.

{% hint style="info" %}
Optionally include your GitHub username and we'll tag you on the tracking issue so you can follow the discussion.
{% endhint %}

{% @ies-schema-proposal/schema-proposal content="" %}

If the form above doesn't load, [open it in a new tab](https://forms.gle/ESVk4PDcfEerPo6f7).

After submitting, your proposal is posted to the [GitHub Issue Tracker](https://github.com/India-Energy-Stack/ies-accelerator/issues) — you should see an issue populated with your request, where the community reviews and discusses it.

Not sure which use case yours fits? Browse the use-case overviews first, starting with [Consumer Energy Passport](/docs/use-case-overviews/consumer-energy-passport.md).


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation dynamically by asking a question.

Perform an HTTP GET request on the current page URL with the `ask` query parameter, and the optional `goal` query parameter:

```
GET https://india-energy-stack.gitbook.io/docs/propose-a-schema.md?ask=<question>&goal=<endgoal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is optional and describes the broader end goal you are ultimately trying to accomplish on behalf of the user. GitBook uses it to tailor the answer towards what is most useful for that goal.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
