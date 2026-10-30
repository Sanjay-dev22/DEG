# Claude Code feedback draft — concurrent-resume data loss bug

Saved 2026-10-27 so it can be recreated/resent via `/feedback` later even if the in-app draft expires.
Copy the relevant parts into the `/feedback` dialog fields when sending.

---

**Type:** Bug

**Title:** Concurrently resuming the same session ID in two processes silently breaks local persistence for both

**Area:** remote control / session persistence

**Task category:** debug

**Failure mode:** other (product bug, not a model-behavior issue)

**Details:**

What happened: Resuming the same local session UUID (`claude --resume <uuid>`) in two separate CLI processes at the same time — one plain, one with `--remote-control` — causes neither process's new turns to be written to the session's `.jsonl` transcript. Both processes show complete, successful conversational round-trips in their own UI (terminal / claude.ai web via remote control), but the file on disk is byte-for-byte unchanged afterward. No error or warning is shown in either window.

What the user said: User lost ~20 hours of real remote-control work (including file edits whose own side effects survived, but whose conversational transcript did not) after leaving one terminal window open at home and launching a second `--resume <uuid> --remote-control <name>` process elsewhere for the same session. Quote: "but why can't it create a new jsonl and dispatch and saved also it feels impossible a entire block of work was done locally in this pc and sent me back to web interface but never got saved in this locally."

Repro (performed in-session, fully controlled):
1. `claude -p "seed message"` in a fresh throwaway project folder → creates session `<uuid>`.
2. Open Terminal A: `claude --resume <uuid>` (no remote control), leave idle.
3. Open Terminal B: `claude --resume <uuid> --remote-control <name>`.
4. Via claude.ai (remote control bridge), send a message in Terminal B's session — get a full, real reply.
5. Type a message directly into Terminal A — get a full, real reply.
6. Check `<uuid>.jsonl`: line count and byte size are identical to step 1's seed, for both exchanges. Neither message nor reply from either terminal appears anywhere in the file.

Evidence: session UUID `c175ff2d-5399-4d67-9cf6-cf6f2f13ea1e`, project `C--Users-Sanjay-Desktop-rc-clobber-test`, file stayed at 28 lines / 302857 bytes through both exchanges (test artifacts since deleted — this doc is the durable record). Real incident this was reproducing involved session UUIDs `9424322c-69d4-4687-90ee-8946f6233773` and `72adb1ff-e560-4255-8607-e89a202e24f3` under project `C--Users-Sanjay-Desktop-DEG`, with a clean ~20-hour gap in the transcript (2026-10-26T20:19:28Z to 2026-10-27T16:49:32Z) corresponding to the lost remote-control session.

Impact: silent, unrecoverable local data loss with zero user-facing indication — the conversation looks completely normal and successful in both the terminal and the web UI while it's happening.
