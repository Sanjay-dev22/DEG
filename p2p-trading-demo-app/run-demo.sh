#!/usr/bin/env bash
# One-shot launcher for the P2P trading demo (flow B: grid <-> aggregator <-> pooled sellers).
#
#   ./run-demo.sh up [--tunnel]   start onix network + policy server + 4 apps
#   ./run-demo.sh flow [--seed]   run flow B through the apps' REST APIs
#   ./run-demo.sh tunnel          expose the 4 dashboards on public URLs (cloudflared)
#   ./run-demo.sh reset           wipe all four apps' state
#   ./run-demo.sh down            stop everything
#
# --tunnel (on `up`) also tunnels onix-buyerapp (:8081) BEFORE buyer-app starts, so the shared
#   discovery service can deliver on_discover to a public address and real "Discover offers" works.
# --seed (on `flow`) bypasses discovery by copying seller-app's own live offers into buyer-app's
#   discovered_offers table. Use it only where no public address is possible (e.g. a locked-down sandbox).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVKIT="$ROOT/network/devkits/p2p-trading-ies-wave2"
RUN="$ROOT/.run"; mkdir -p "$RUN"
APPS=(seller:4002 buyer:4001 aggregator:4003 grid:4004)
IMAGE=fidedocker/onix-adapter-deg:v2
J=(-H 'content-type: application/json')

log() { printf '\033[1;36m==> %s\033[0m\n' "$*"; }
die() { printf '\033[1;31m%s\033[0m\n' "$*" >&2; exit 1; }
need() { command -v "$1" >/dev/null || die "missing dependency: $1"; }

compose() {
  local files=(-f docker-compose.yml)
  # Behind a TLS-inspecting proxy? Set CA_BUNDLE=/path/to/ca.pem and the onix containers will trust it.
  [[ -z "${CA_BUNDLE:-}" && -f /root/.ccr/ca-bundle.crt ]] && export CA_BUNDLE=/root/.ccr/ca-bundle.crt
  [[ -n "${CA_BUNDLE:-}" ]] && files+=(-f docker-compose.proxy-ca.yml)
  (cd "$DEVKIT/install" && docker compose "${files[@]}" "$@")
}

pull_image() {
  # Docker Hub rate-limits anonymous pulls; mirror.gcr.io needs no login.
  docker image inspect "$1" >/dev/null 2>&1 && return
  docker pull -q "$1" 2>/dev/null || { docker pull -q "mirror.gcr.io/$1" && docker tag "mirror.gcr.io/$1" "$1"; }
}

# bg <name> <dir> <cmd...>: start detached, fully disconnected from our stdio, pid recorded.
bg() {
  local name=$1 dir=$2; shift 2
  (cd "$dir" && exec setsid nohup "$@" >"$RUN/$name.log" 2>&1 </dev/null) &
  echo $! >"$RUN/$name.pid"
}

wait_http() { # url, tries
  for _ in $(seq "${2:-60}"); do curl -sf -m 2 -o /dev/null "$1" && return 0; sleep 1; done; return 1
}

start_tunnel() { # name, local-port -> prints public url
  local name=$1 port=$2 logf="$RUN/tunnel-$1.log"
  need cloudflared
  bg "tunnel-$name" "$RUN" cloudflared tunnel --no-autoupdate --url "http://localhost:$port"
  for _ in $(seq 40); do
    url=$(grep -o 'https://[a-z0-9-]*\.trycloudflare\.com' "$logf" | head -1 || true)
    [[ -n "$url" ]] && { echo "$url"; return; }; sleep 1
  done
  die "cloudflared did not produce a URL for $name (see $logf)"
}

cmd_up() {
  need docker; need node; need npm; need python3; need curl
  docker info >/dev/null 2>&1 || die "docker daemon is not running"
  local tunnel=0; [[ "${1:-}" == "--tunnel" ]] && tunnel=1

  log "pulling images"
  for i in "$IMAGE" redis:alpine caddy:alpine fidedocker/sandbox-2.0:latest; do pull_image "$i"; done

  log "starting policy file server on :8099"
  if ! curl -sf -m 2 -o /dev/null http://localhost:8099/; then
    bg policy "$ROOT/network/specification/policies" python3 -m http.server 8099
  fi

  log "starting onix network (seller, buyer, aggregator, grid + ledgers + router)"
  compose up -d --no-build --pull never
  sleep 8
  compose ps --format '{{.Name}}\t{{.Status}}'

  if (( tunnel )); then
    log "tunnelling onix-buyerapp (:8081) so real discover can reach us"
    pub=$(start_tunnel onix-buyer 8081); echo "$pub" >"$ROOT/buyer-app/public-bap-uri.txt"; echo "   $pub"
  fi

  log "installing + starting the four apps"
  for a in "${APPS[@]}"; do
    n=${a%%:*}; p=${a##*:}
    [[ -d "$ROOT/$n-app/node_modules" ]] || (cd "$ROOT/$n-app" && npm install --silent)
    if ! curl -sf -m 2 -o /dev/null "http://localhost:$p/api/health"; then
      bg "$n-app" "$ROOT/$n-app" npm start
    fi
    wait_http "http://localhost:$p/api/health" 30 || die "$n-app did not start (see $RUN/$n-app.log)"
  done

  log "ready"
  cat <<EOF
   Seller      http://localhost:4002
   Buyer       http://localhost:4001
   Aggregator  http://localhost:4003
   Grid/DISCOM http://localhost:4004
 Next: ./run-demo.sh flow     (or drive the dashboards by hand; README "B. Demand-first aggregation")
       ./run-demo.sh tunnel   (public URLs for the dashboards)
EOF
}

cmd_tunnel() {
  need cloudflared
  log "public dashboard URLs (keep this shell open; Ctrl-C or './run-demo.sh down' stops them)"
  for a in "${APPS[@]}"; do
    n=${a%%:*}; p=${a##*:}
    printf '   %-11s %s\n' "$n" "$(start_tunnel "dash-$n" "$p")"
  done
  wait
}

jget() { node -pe "const d=JSON.parse(require('fs').readFileSync(0,'utf8'));$1"; }

cmd_flow() {
  local seed=0; [[ "${1:-}" == "--seed" ]] && seed=1
  log "resetting the four apps"
  for a in "${APPS[@]}"; do curl -s -X POST "localhost:${a##*:}/api/reset" >/dev/null; done

  log "seller: publishing 3 offers (5kWh@10, 8kWh@11.5, 10kWh@12)"
  for p in "5 10" "8 11.5" "10 12"; do set -- $p
    curl -s -m 90 -X POST localhost:4002/api/publish "${J[@]}" -d "{\"quantityKwh\":$1,\"pricePerKwh\":$2}" | jget 'd.ok?"  published "+d.offer.id:JSON.stringify(d)'
  done

  log "grid: posting requirement 20 kWh, max Rs13/kWh"
  REQ=$(curl -s -X POST localhost:4004/api/requirements "${J[@]}" -d '{"quantityKwh":20,"maxPricePerKwh":13}' | jget 'd.id'); echo "  $REQ"

  if (( seed )); then
    log "discovery BYPASSED (--seed): copying seller-app's live offers into buyer-app's discovered_offers"
    curl -s localhost:4002/api/offers | (cd "$ROOT" && node -e '
      const {DatabaseSync}=require("node:sqlite");const db=new DatabaseSync("buyer-app/buyer-app.db");
      for(const x of JSON.parse(require("fs").readFileSync(0,"utf8")))
        db.prepare("INSERT OR REPLACE INTO discovered_offers (offer_id,seller_id,name,price_per_kwh,available_qty,discovered_at,raw_json,bpp_uri) VALUES (?,?,?,?,?,?,?,?)")
          .run(x.id,"sellerapp.example.com","LOCAL-SEED (discover bypassed)",x.price_per_kwh,x.remaining_qty,new Date().toISOString(),"{}","http://sellerapp.example.com:9000/bpp/receiver")' 2>/dev/null)
  else
    log "aggregator: real discover (needs a public address -- start with './run-demo.sh up --tunnel')"
    for _ in $(seq 12); do
      curl -s -m 60 -X POST localhost:4003/api/discover "${J[@]}" -d '{}' >/dev/null
      sleep 10
      n=$(curl -s localhost:4003/api/available-offers | jget 'd.length'); echo "  available offers: $n"
      (( n >= 3 )) && break
    done
    (( n >= 1 )) || die "discover returned nothing. Use --tunnel on 'up', or rerun with --seed"
  fi

  log "aggregator: recommend pool"
  REC=$(curl -s -X POST "localhost:4003/api/requirements/$REQ/recommend")
  echo "$REC" | jget 'd.note+"  blended base Rs"+d.blendedBasePrice'
  echo "$REC" | jget 'd.picked.map(p=>[p.offerId,p.pricePerKwh,p.takeQty].join(" ")).join("\n")' | while read -r o pr q; do
    curl -s -X POST localhost:4003/api/pool/enroll "${J[@]}" -d "{\"offerId\":\"$o\",\"sellerId\":\"sellerapp.example.com\",\"pricePerKwh\":$pr,\"qty\":$q}" >/dev/null
  done

  log "aggregator: publishing pooled block (+Rs0.30 margin)"
  curl -s -m 90 -X POST localhost:4003/api/pool/publish "${J[@]}" -d "{\"requirementId\":\"$REQ\",\"marginPerKwh\":0.30}" | jget 'd.ok?"  block "+d.block.id+" @ Rs"+d.block.blended_price_per_kwh:JSON.stringify(d)'

  log "grid: buying the block (real init -> confirm via onix-gridapp)"
  curl -s -m 90 -X POST "localhost:4004/api/requirements/$REQ/buy" "${J[@]}" -d '{}' | jget 'd.note||JSON.stringify(d)'
  for _ in $(seq 30); do
    st=$(curl -s localhost:4004/api/trades | jget 'd[0]?d[0].status:"-"'); [[ "$st" == ACTIVE ]] && break; sleep 2
  done
  [[ "$st" == ACTIVE ]] || die "trade did not reach ACTIVE (status=$st). Check 'docker logs onix-gridapp'"
  TXN=$(curl -s localhost:4004/api/trades | jget 'd[0].transactionId')

  log "aggregator: reporting delivery of 19.2 of 20 kWh"
  curl -s -m 90 -X POST "localhost:4003/api/deliver/$TXN" "${J[@]}" -d '{"finalAlloc":19.2}' | jget 'd.trade.status+"  pool receives Rs"+d.trade.settlementAmount'
  sleep 8
  log "result"
  echo -n "  grid trade:  "; curl -s localhost:4004/api/trades | jget 'd[0].status+"  grid pays Rs"+d[0].settlementAmount'
  echo -n "  requirement: "; curl -s localhost:4004/api/requirements | jget 'd[0].status'
  curl -s localhost:4003/api/blocks | jget '
    const x=d[0].disaggregation;
    x.memberPayouts.map(m=>"  seller "+m.offerId+"  net Rs"+m.net).join("\n")+"\n  aggregator margin Rs"+x.aggregatorMargin'
}

cmd_reset() { for a in "${APPS[@]}"; do curl -s -X POST "localhost:${a##*:}/api/reset" >/dev/null && echo "reset ${a%%:*}-app"; done; }

cmd_down() {
  log "stopping tunnels, apps, policy server, containers"
  # each bg() job is its own session leader, so -PID signals the whole group (npm + node child)
  for f in "$RUN"/*.pid; do
    [[ -f "$f" ]] || continue
    kill -- "-$(cat "$f")" 2>/dev/null || kill "$(cat "$f")" 2>/dev/null || true; rm -f "$f"
  done
  compose down 2>/dev/null || true
  rm -f "$ROOT/buyer-app/public-bap-uri.txt"
}

case "${1:-}" in
  up) shift; cmd_up "$@" ;;
  flow) shift; cmd_flow "$@" ;;
  tunnel) cmd_tunnel ;;
  reset) cmd_reset ;;
  down) cmd_down ;;
  *) sed -n '2,13p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 1 ;;
esac
