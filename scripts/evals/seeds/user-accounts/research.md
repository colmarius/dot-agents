# Research: User accounts for notes-api

Date: 2026-11-15
Question: Which ways of adding user accounts fit this API, so that each person sees only their own notes? What do authoritative sources require for passwords, tokens, and object-level authorization?

## Recommendation

Use username and password accounts. Hash passwords with Argon2id from Node's built-in `node:crypto`. Issue opaque, random bearer tokens that the server stores, and scope every note lookup by owner. The API's current shape fits this: one process, an in-memory store, no dependencies, and JSON clients. It also needs no new packages. Confidence: high for the security primitives, which are sourced below. Confidence is medium for the overall fit, because the team has not yet named the clients or the deployment (see Open Questions).

The proposal for review is in [proposal.md](proposal.md).

## Current state of the code (observed at the initial commit)

- `src/app.js` routes `GET/POST /notes` and `GET/DELETE /notes/:id` with no authentication. Any caller can read and delete every note.
- `src/store.js` keeps notes in one `Map` with a global sequential `id` (`nextId++`). These guessable IDs are a textbook IDOR setup once multiple users exist.
- The store is in memory. A restart loses all notes, and would also lose users and sessions. Existing notes do not need a data migration.
- `test/app.test.js` calls every endpoint without credentials, so all six tests change once `/notes` requires authentication.
- `docs/api.md` is already out of date: it does not document `tags` on create, the `tags` field on notes, or `GET /notes?tag=`. These are implemented in `src/app.js` and `src/store.js` and tested in `test/app.test.js`.
- The project has no dependencies (`package.json`). The server is plain HTTP (`src/server.js`); TLS, if any, must come from deployment.
- Local runtime: Node v24.19.0 with OpenSSL 3.5.7. `npm test` passes 6/6.

## Findings

### Password storage

- OWASP: use Argon2id with at least 19 MiB of memory, 2 iterations, and parallelism 1. Use scrypt only if Argon2id is unavailable (N=2^17, r=8, p=1), use bcrypt only for legacy systems, and use PBKDF2 only when FIPS-140 is required. [OWASP Password Storage]
- Node 24 ships `crypto.argon2()` / `argon2Sync()` with `argon2id` support ("Added in: v24.7.0"). It takes `message`, `nonce` (salt, at least 8 bytes), `parallelism`, `tagLength`, `memory` (KiB), and `passes`. The docs section shows no experimental banner (checked 2026-11-15). [Node crypto docs]
- Verified locally: `argon2Sync('argon2id', { memory: 19456, passes: 2, parallelism: 1, tagLength: 32, ... })` runs on v24.19.0 and took about 63 ms for one hash. That cost is per login, and per request if passwords were sent on every call. Use the async `argon2()` so hashing does not block the event loop.
- `crypto.scrypt` is also built in (default N=16384, which is below the OWASP minimum, so set it explicitly). It is the fallback if the deploy runtime is older than Node 24.7. [Node crypto docs]
- Compare secrets with `crypto.timingSafeEqual`, which needs buffers of equal length. [Node crypto docs]

### Login behaviour

- Login failures should return one generic error, whether the user does not exist or the password is wrong. Response time should not reveal which case occurred, so hash even when the user is missing. [OWASP Authentication]
- Registration ("username already taken") is also an enumeration vector. OWASP treats a generic response as a trade-off against usability, decided by how critical the data is. [OWASP Authentication]
- Password length: without MFA, NIST SP 800-63B-4 (via OWASP) treats passwords shorter than 15 characters as weak; with MFA the floor is 8. Allow at least 64 characters, allow all characters, impose no composition rules, and never silently truncate. Cap the input length so long inputs cannot be used for denial of service. [OWASP Authentication]
- Throttle failed logins per account rather than per IP. Exponential delay avoids lockout-based denial of service. [OWASP Authentication]

### Session tokens

- Generate tokens with a CSPRNG at ≥128 bits of entropy, preferably ≥160. The server may store only a SHA-256 of the secret and compare it in constant time. Never accept a bare identifier as proof. [OWASP Session Management]
- Enforce idle and absolute timeouts on the server. OWASP gives example idle timeouts of 15–30 min for low-risk apps and absolute timeouts of 4–8 h for a working day. Logout must invalidate the session on the server. [OWASP Session Management]
- Clients send bearer tokens in `Authorization: Bearer <token>`. They SHOULD NOT go in URLs, because URLs get logged. A missing credential gets `401` with `WWW-Authenticate: Bearer`. An expired or invalid token gets `401` with `error="invalid_token"`. Tokens should be short-lived, and TLS is required. [RFC 6750 §2.1, §2.3, §3, §5.3]
- If the client is a browser, prefer `HttpOnly; Secure; SameSite` cookies (`__Host-` prefix) over `localStorage`. Cookies then need CSRF defences, and SameSite alone only adds defence in depth. [OWASP Session Management]

### JWTs (stateless tokens)

- JWTs have well-known pitfalls: `alg` confusion and `none`, weak HMAC keys, and missing `iss`/`aud`/`typ` checks. Applications must pin algorithms and validate every claim. [RFC 8725 §2–3]
- Inference: revoking a stateless JWT at logout needs a server-side denylist, which removes the main advantage over opaque tokens. This server is a single process and already keeps state in memory, so JWTs add risk and code (or a dependency) without a benefit.

### Object-level authorization

- Without an owner check on every object access, IDs in URLs are an IDOR. Scope the lookup to the current user (`findByIdAndOwnerId`). When existence is sensitive, return the same `404` for "missing" and "not yours". Test with two users, each trying to reach the other's objects. [OWASP IDOR]

## Options considered

| Option | Fit for this API | Main cost or risk |
| --- | --- | --- |
| A. Passwords + opaque server-side bearer tokens | Good: no dependencies, simple revocation, fits JSON clients | We own password storage, throttling, and expiry |
| B. Passwords + stateless JWT | Poor: one process, logout needs a denylist anyway | Hand-rolled JWTs or a new dependency; RFC 8725 pitfalls |
| C. Passwords + cookie sessions | Good only if the main client is a browser | Requires CSRF protection; awkward for CLI/API clients |
| D. External identity provider (OIDC) | Good if the org already runs one | New infrastructure and config; no offline tests without stubs |
| E. Admin-issued per-user API keys | Fine for a handful of known users | No self-service sign-up, rotation, or expiry by default |
| F. HTTP Basic auth on every request | Poor | Argon2 cost (~63 ms) on every request; password sent on each call |

Options A and C differ only in how the client carries the token. If browsers become a client, the same session store can also be issued as a cookie later.

## Sources

- [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html): algorithm choice and minimum Argon2id/scrypt parameters.
- [Node.js v24 `crypto` docs](https://nodejs.org/docs/latest-v24.x/api/crypto.html): `argon2()` (added v24.7.0), `scrypt()` defaults, `randomBytes()`, `timingSafeEqual()`.
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html): generic errors, timing, password length, throttling.
- [OWASP Session Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html): token entropy, hashed storage, timeouts, logout, cookie attributes.
- [RFC 6750: OAuth 2.0 Bearer Token Usage](https://datatracker.ietf.org/doc/html/rfc6750): `Authorization: Bearer`, `WWW-Authenticate` challenges, `invalid_token`, no tokens in URLs.
- [RFC 8725: JWT Best Current Practices](https://datatracker.ietf.org/doc/html/rfc8725): JWT threats and required validations.
- [OWASP IDOR Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Insecure_Direct_Object_Reference_Prevention_Cheat_Sheet.html): owner-scoped lookups, uniform 404, two-user tests.

## Open Questions

- Who are the clients: a CLI or scripts, a browser app, or both? This decides bearer header vs cookie (A vs C).
- Does the organization already run an identity provider? If so, option D may beat building password storage.
- How is it deployed, and where does TLS terminate? Bearer tokens and passwords require TLS.
- Is losing accounts on restart acceptable? Persistence is outside this work, but accounts make in-memory storage much more painful.
- What Node version runs in deployment? `crypto.argon2` needs ≥ 24.7.0; otherwise use scrypt.

