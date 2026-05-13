# XP Execution Lifecycle

The 9-step lifecycle a Code Migration travels from intent to commit. The Malvins XP Team (installed globally) drives each step. `/run-migrations` orchestrates them.

## The XP Team

| Agent | Role |
|---|---|
| `xp-pair-navigator` | Reads the intent, plans the smallest next step, sets direction. |
| `xp-pair-driver` | Implements in TDD: red → green → refactor, tiny increments. |
| `xp-coach-k` | Validates XP discipline; enforces DoD; closes the migration. |
| `xp-refactor-techdebt-hunter` | Scans for smells once tests are green; either fixes or files follow-ups. |

## Assumed principles (Kent Beck, XP Explained, Part II)

- Pair programming (Navigator + Driver).
- Test-Driven Development.
- Incremental delivery — smallest useful step.
- Continuous refactoring after green.
- Simplicity first. No speculative abstraction.
- No overengineering.

## The 9 steps

1. **Migration selected.** Next `pending` migration is picked from [../code-migrations/code_migrations.yml](../code-migrations/code_migrations.yml).
2. **Navigator analyzes intent.** Reads the `.migration.md` file, identifies the smallest next step, surfaces missing acceptance criteria or risks.
3. **Driver implements incrementally.** TDD loop. One failing test, one passing change, refactor, repeat. No bulk commits, no big-bang rewrites.
4. **Coach validates XP discipline.** Confirms the loop is genuinely incremental, tests precede implementation, scope hasn't drifted.
5. **Refactor agent evaluates technical debt.** Post-green scan for smells. Trivial cleanups happen in-migration; non-trivial debt becomes a new migration intent.
6. **Tests executed.** Full suite — `bin/rails test`, plus `bin/rails test:system` if relevant. Green is non-negotiable.
7. **DoD verified.** Coach walks [DOD.md](DOD.md) item by item, including project-specific additions (fairness queue, auth boundary, multi-DB, mailer).
8. **Migration execution logged.** Execution record written to `code-migrations/execution/<id>.yml` ([template](../ai/templates/execution.template.yml)). Index in `code_migrations.yml` flips to `completed`.
9. **Commit linked.** Single commit referencing the migration id. Commit SHA recorded in the execution log so `git log` and the operational history line up.

## When the lifecycle does not apply

- Rails schema migrations (`db/migrate/`) — those follow Rails' own lifecycle, not this one.
- Trivial chores (typos, dependency bumps with no behavioral effect) — commit directly without an intent.
- Emergency hotfixes — commit first to stop the bleeding, then write a retrospective intent so the history stays auditable.
