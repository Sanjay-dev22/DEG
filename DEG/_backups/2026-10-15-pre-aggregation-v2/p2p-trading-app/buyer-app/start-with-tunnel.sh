#!/bin/bash
# Restart helper: buyer-app's discover only works when PUBLIC_BAP_URI points
# at the cloudflared tunnel exposing onix-buyerapp:8081 (see beckn.js) — this
# has to be re-set on every restart since it isn't persisted anywhere else.
export PUBLIC_BAP_URI="https://scale-media-massive-creativity.trycloudflare.com"
cd "$(dirname "$0")"
exec node server.js
