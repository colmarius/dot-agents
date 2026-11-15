# Log

- 2026-11-15 — Read `src/`, `test/`, and `docs/api.md` at the initial commit; `npm test` passed 6/6. Researched OWASP password storage, authentication, session, and IDOR guidance, the Node v24 `crypto` docs, and RFCs 6750 and 8725. Checked locally that `crypto.argon2('argon2id', m=19456, t=2, p=1)` works on Node v24.19.0 (~63 ms per hash). Wrote research.md and proposal.md. Found that `docs/api.md` already omits `tags` and `?tag=`; this is folded into delivery slice 4. Gaps: clients, deployment/TLS, and deploy Node version are unknown (research.md Open Questions).

