---
name: documentation
description: "Scans and maintains evidence-backed project documentation. Use for docs initialization, architecture, ADRs, runbooks, APIs, or work-item promotion. Triggers on: documentation scan, initialize docs, document architecture, update docs."
---

# Documentation

Discover the repository's documentation convention, assess selected topics against repository evidence, and create or update only the canonical documents the user wants.

## Core Rules

1. Treat project documentation as durable human-and-agent knowledge, separate from task state in `.agents/work/`.
2. Discover an existing canonical documentation location before proposing `docs/`.
3. Run scans read-only. Show coverage and recommendations before writing unless the user already selected topics and asked for changes.
4. Create directories only when adding a useful document; never scaffold an empty taxonomy.
5. Derive technical facts from current repository evidence. Label unknown policy or intent instead of guessing.
6. Link to existing generated or canonical material instead of duplicating it.
7. Preserve the repository's existing style, structure, and documentation tooling.

## Modes

- **Scan**: inventory documentation, evaluate selected or all topics, and report gaps without editing.
- **Initialize**: establish a canonical documentation location after user approval.
- **Create or update**: write selected documents from verified evidence.
- **Verify**: compare existing documentation with code, tests, schemas, configuration, and infrastructure.
- **Promote**: move enduring knowledge from a work item into canonical project documentation and link both locations.

## Workflow

### 1. Discover Existing Documentation

Inspect likely entrypoints before choosing a location:

```text
README.md
CONTRIBUTING.md
SECURITY.md
docs/
doc/
documentation/
architecture/
adr/
.github/
package- or module-level README files
documentation-site configuration and build scripts
```

Also inspect links from `README.md` and `AGENTS.md`.

- If a canonical location exists, use it.
- If documentation is intentionally distributed, preserve that arrangement.
- If competing locations make ownership ambiguous, ask which is canonical.
- If no canonical location exists, offer to initialize `docs/`; do not create it without user approval.

### 2. Choose Scan Topics

Use the topics requested by the user. If none are specified, scan all topics at summary depth and let the user select which findings to act on.

| Topic | Typical contents |
| --- | --- |
| `architecture` | Current structure, views, concepts, diagrams, and architecture decisions |
| `development` | Local setup, testing, debugging, and conventions |
| `operations` | Deployment, monitoring, configuration, backup, recovery, and rollback |
| `security` | Threat model, trust boundaries, authentication, authorization, secrets, and security rules |
| `runbooks` | Actionable incident and operational procedures |
| `specifications` | Durable behavioral, protocol, state, and interface contracts |
| `api` | API contracts, authentication, errors, versioning, and examples |
| `data` | Schema ownership, migrations, consistency, retention, and classification |
| `product` | Stable domain language, roles, capabilities, workflows, and product invariants |
| `contributing` | Review, release, contribution, and required-check processes |

These names are a proposed taxonomy, not mandatory paths. Follow established repository conventions such as a root `CONTRIBUTING.md`, generated API reference, or existing `doc/adr/` directory.

### 3. Gather Evidence

Use the narrowest repository evidence that can support each selected topic:

| Evidence | Can establish |
| --- | --- |
| Source code | Implemented behavior and boundaries |
| Tests | Expected and protected behavior |
| Schemas and migrations | Structural API and data contracts |
| Configuration and infrastructure | Available mechanisms and deployed topology |
| CI workflows | Enforced checks and contribution flow |
| Existing docs and decisions | Declared intent, policy, and rationale |
| User confirmation | Product intent and organizational policy |

Do not promote an implementation detail into policy without supporting documentation or user confirmation. Be especially conservative with security, retention, compliance, SLOs, incident response, and product intent.

### 4. Report the Scan

Include:

1. Existing documentation locations and the likely canonical location.
2. Coverage per selected topic: `strong`, `partial`, `missing`, or `insufficient evidence`.
3. Evidence inspected.
4. Suggested action: keep, link, update, create, or confirm with the user.
5. A concise list of candidate documents.

Example:

```markdown
| Topic | Coverage | Evidence | Suggested action |
| --- | --- | --- | --- |
| Architecture | Partial | Service modules, deployment config | Add overview |
| API | Strong | OpenAPI source | Link; do not duplicate |
| Runbooks | Missing | No operational procedure found | Requires operator input |
```

For a scan-only request, stop here.

### 5. Create or Update Selected Documentation

After the user selects topics, create only documents supported by evidence. If initializing `docs/`, start with `docs/README.md` plus the selected content. Add a topic directory only when placing a real document inside it.

Possible mature structure:

```text
docs/
├── architecture/
├── development/
├── operations/
├── security/
├── runbooks/
├── specifications/
├── api/
├── data/
├── product/
└── contributing/
```

Do not create this whole tree by default.

For generated documents:

- State current behavior separately from desired policy.
- Add source paths or a short `Sources` section when it helps future verification.
- Mark drafts and unresolved questions clearly.
- Prefer text-based diagram sources when the repository supports them; keep rendered assets beside their source.
- Keep architecture decisions short, one decision per file, with status, context, decision, rationale, consequences, and links.
- Supersede accepted decisions with a new record rather than silently rewriting their history.

### 6. Promote Work-Item Knowledge

When a decision or finding under `.agents/work/<category>/<slug>/` becomes relevant to future unrelated work:

1. Find the repository's canonical documentation or decision location.
2. Create or update the canonical document with the enduring result, not the work-item transcript.
3. Link from the work item to the canonical document and back when useful.
4. Avoid two competing sources of truth.
5. Update `AGENTS.md` only when agents need a concise navigation pointer or universal instruction.

## Verification

After writing:

- Check local links and referenced paths.
- Run the repository's Markdown or documentation checks when available.
- Re-read claims against the evidence used to write them.
- Report anything that still requires domain-owner, security, product, or operations review.

## Definition Of Done

Documentation work is done when the canonical location is respected, only selected and evidence-backed documents were changed, navigation points to the new material, relevant checks pass, and unsupported claims are explicitly left as questions rather than presented as facts.
