# 1. Adopt Malvins XP Team workflow and Code Migrations

- **Status**: accepted
- **Date**: 2026-05-13
- **Deciders**: Michael Lins

## Context

The project has reached production (commit `f88a5f4` deployed to `suporte.adoteumfilhopovo.org.br`, database seeded with 7,408 Pnas from Joshua Project). Until now, changes have flowed straight from idea to commit, with no operational record of intent, acceptance criteria, or post-implementation review. As the codebase moves from "get it live" to "evolve it safely", that informal flow stops being sufficient:

- The adoption fairness queue (`Pna.proximo_da_fila`) is load-bearing; changes there need pinned tests and an audit trail.
- Several production follow-ups are known but unstructured (Cloudflare DNS cutover, empty `prayer_cards` volume, missing SendGrid, no admin user, missing `image_processing` gem). Without an intent backlog, these get lost.
- AI-assisted work is becoming the default. Without a disciplined workflow, AI accelerates churn instead of velocity.

## Decision

Adopt the Malvins XP Team workflow and Code Migrations system for this repository:

1. Operational structure under `/ai/`, `/code-migrations/`, `/docs/` (bootstrapped by `project-setupper`).
2. Change intent recorded as `.migration.md` files under `code-migrations/intents/`, indexed in `code-migrations/code_migrations.yml`.
3. Execution driven by `/run-migrations`, orchestrating the global XP Team agents (`xp-pair-navigator` → `xp-pair-driver` → `xp-coach-k` + `xp-refactor-techdebt-hunter`).
4. Definition of Done enforced before commit (base DoD plus project-specific items in [../DOD.md](../DOD.md)).
5. Execution metadata persisted to `code-migrations/execution/<id>.yml`, with the commit SHA linked back to the intent.

Rails schema migrations (`db/migrate/`) and trivial chores remain outside this system. "Run migrations" in this repo means **Code Migrations**, not `bin/rails db:migrate`.

## Consequences

### Positive

- Every behavioral change carries an explicit intent, acceptance criteria, and an execution record. `git log` and `code-migrations/execution/` together give a full audit trail.
- TDD and incremental delivery become the default. The fairness queue and other load-bearing code get the tests they deserve before drift accumulates.
- Production follow-ups (DNS, prayer_cards volume, SendGrid, admin user, `image_processing`) can be enqueued as discrete migrations instead of floating as memory.
- AI-assisted work is bounded by a workflow that values simplicity, test-first, and post-green refactor — not speculative code generation.

### Negative

- Every non-trivial change now requires authoring an intent before code. For a sole maintainer that is friction.
- Two systems coexist with the same vocabulary (Rails db migrations vs Code Migrations). Mistakes are likely until the distinction becomes muscle memory.
- The workflow only pays off if the discipline is maintained. If intents start being written *after* the code, the audit trail loses meaning.

### Neutral

- No change to the runtime stack, deploy pipeline, or test framework. This decision is purely operational.
- The existing `CLAUDE.md` remains the source of truth for project context; this decision adds workflow on top, it does not replace context docs.
