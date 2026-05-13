# Workflow

Operational flow for Code Migrations in this project. For project context (stack, domain, deploy), see [../CLAUDE.md](../CLAUDE.md).

## Operational flow

```
migration selected → execution → DoD verified → execution log → commit
```

1. **Selection.** Pick the next `pending` migration from [../code-migrations/code_migrations.yml](../code-migrations/code_migrations.yml), or author a new intent under [../code-migrations/intents/](../code-migrations/intents/) using [../ai/templates/migration.template.md](../ai/templates/migration.template.md).
2. **Execution.** Run `/run-migrations`. The XP Team agents (see [XP_LIFECYCLE.md](XP_LIFECYCLE.md)) execute the intent under TDD — Navigator plans, Driver implements, Coach validates, Refactor Hunter sweeps for debt.
3. **DoD.** Validate against [DOD.md](DOD.md). The migration is not closed until every item passes.
4. **Execution log.** A record is written to [../code-migrations/execution/](../code-migrations/execution/)`<id>.yml` following [../ai/templates/execution.template.yml](../ai/templates/execution.template.yml). The status in `code_migrations.yml` flips to `completed`.
5. **Commit.** A single commit per migration. The commit message references the migration id so `git log` and the execution log line up.

## File conventions

### Migration intents

- Path: `code-migrations/intents/YYYYMMDDHHMMSS_snake_case_name.migration.md`
- Extension is **always `.migration.md`**. Never `.rb`. These are operational specifications, not Ruby code.
- The 14-digit timestamp is the migration id, used in the index, the execution record, and (typically) the commit body.

### Execution records

- Path: `code-migrations/execution/YYYYMMDDHHMMSS.yml`
- One per executed migration. Generated, not hand-edited.
- Captures: id, name, status, intent checksum, dependencies, timestamps, agents involved, commit SHA, created/modified/removed files, test results, DoD result.

### Index

- Path: `code-migrations/code_migrations.yml`
- The single source of truth for migration state. Lists every migration with its current `status`. `/run-migrations` reads from this file.

## What is NOT a Code Migration

- Rails schema migrations under `db/migrate/` — those are run via `bin/rails db:migrate`.
- Trivial one-off chores that don't justify a recorded intent (typo fixes, dependency bumps without behavioral change). Just commit those.
- Speculative refactors with no acceptance criteria. Either pair them with a real change (one migration) or skip them.

## Triggering the workflow

- `/run-migrations` — execute the next pending migration.
- Natural language: "run migrations", "rode as migrations", "execute as migrations pendentes" — all map to the same skill.

"Run migrations" in this repo means **Code Migrations** (intent specs), not `bin/rails db:migrate`. Rails schema work uses `bin/rails db:migrate` and stays out of `/code-migrations/`.
