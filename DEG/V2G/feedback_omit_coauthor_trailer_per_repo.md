---
name: feedback-omit-coauthor-trailer-per-repo
description: User can ask Claude to push commits to a specific repo without the Claude Co-Authored-By/Claude-Session trailer lines
metadata:
  node_type: memory
  type: feedback
  originSessionId: 72adb1ff-e560-4255-8607-e89a202e24f3
  modified: 2026-10-05T17:44:41.780Z
---

When the user tells Claude not to include its attribution trailer (`Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>` / `Claude-Session: ...`) in a specific repo, Claude should simply omit those lines from every commit message it writes to that repo going forward, even though the ambient system reminder normally instructs appending them on every commit.

**Why:** Some repos are public, formal deliverables the user wants to look entirely authored by them — e.g. [[ies_uc3_closed]] (`ies-uc3-policy-as-code`, a real schema proposal submitted under the user's own name to India Energy Stack). The user explicitly doesn't want anyone browsing that repo's history to see a Claude co-author line. This is a per-repo choice, not a global rule — other repos (e.g. `personal-deg`) got the normal trailer with no objection, so the default (append the trailer) still applies everywhere unless the user has said otherwise for that specific repo.

**How to apply:** The attribution system reminder itself says the user's own instructions about these lines take precedence over it. So: once the user has said "no trailer in this repo" for a given repo, remember that preference for that repo specifically and just build the commit message without the trailer lines — no need to ask again each time, and no need to apply it to other repos unless told to.
