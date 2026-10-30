// Outbound half of the Beckn signature flow: builds a real message, signs it
// with our own real Ed25519 key (§1.5), and sends it as a real HTTP POST to
// our own live, deployed endpoint -- the self-loopback test proving both
// halves (outbound signing here, inbound verification in route.ts) actually
// interoperate, over the real internet, not just in local unit tests.
//
// Signing-string construction matches beckn-onix's real signer.go exactly
// (verified by reading its source earlier): 3-line
// (created)/(expires)/digest string, BLAKE2b-512 digest of the raw body,
// Ed25519 signature, same Authorization header shape route.ts parses.
//
// Usage: node send-signed-message.mjs [--tamper]
//   --tamper  sends a body that doesn't match what was signed, to prove
//             the endpoint correctly rejects a tampered message too.

import { readFileSync } from "node:fs";
import { createHash, createPrivateKey, sign } from "node:crypto";

const SUBSCRIBER_ID = "www.nharuvi.com";
const UNIQUE_KEY_ID = "key-1";
const ENDPOINT = "https://www.nharuvi.com/api/beckn/v1";

const seed = Buffer.from(
  readFileSync(new URL("./beckn-keys/signing-private-key.b64", import.meta.url), "utf-8").trim(),
  "base64"
);

// Ed25519 raw seed -> PKCS8 DER (same fixed prefix used and verified earlier
// in this same registration work).
const PKCS8_PREFIX = Buffer.from("302e020100300506032b657004220420", "hex");
const privateKey = createPrivateKey({
  key: Buffer.concat([PKCS8_PREFIX, seed]),
  format: "der",
  type: "pkcs8",
});

function signingString(rawBody, created, expires) {
  const digest = createHash("blake2b512").update(rawBody, "utf-8").digest("base64");
  return `(created): ${created}\n(expires): ${expires}\ndigest: BLAKE-512=${digest}`;
}

// A real, plausible Beckn-shaped message -- self-addressed, not a toy string.
const now = new Date();
const body = {
  context: {
    version: "2.0.0",
    action: "search",
    domain: "beckn.one:deg:v2g-selftest:0.1.0",
    bap_id: SUBSCRIBER_ID,
    bap_uri: ENDPOINT,
    transactionId: crypto.randomUUID(),
    messageId: crypto.randomUUID(),
    timestamp: now.toISOString(),
  },
  message: {
    note: "Nharuvi Energy self-loopback test -- proving outbound signing and inbound verification interoperate over the real deployed endpoint.",
  },
};
const rawBody = JSON.stringify(body);

const created = Math.floor(now.getTime() / 1000);
const expires = created + 30;

const msg = signingString(rawBody, created, expires);
const signature = sign(null, Buffer.from(msg, "utf-8"), privateKey).toString("base64");

const authHeader =
  `Signature keyId="${SUBSCRIBER_ID}|${UNIQUE_KEY_ID}|ed25519",algorithm="ed25519",` +
  `created="${created}",expires="${expires}",headers="(created) (expires) digest",` +
  `signature="${signature}"`;

const tamper = process.argv.includes("--tamper");
const sentBody = tamper ? rawBody.replace('"search"', '"tampered"') : rawBody;

console.log(`=== Sending ${tamper ? "DELIBERATELY TAMPERED" : "validly signed"} request to ${ENDPOINT} ===`);
console.log("Authorization:", authHeader);
console.log("");

const res = await fetch(ENDPOINT, {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    Authorization: authHeader,
  },
  body: sentBody,
});

const responseBody = await res.json();
console.log(`HTTP ${res.status}`);
console.log(JSON.stringify(responseBody, null, 2));
