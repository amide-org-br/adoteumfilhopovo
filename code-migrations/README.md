# Code Migrations

Operational specifications for incremental, traceable changes to this project, driven by the Malvins XP Team workflow. **Not** Rails `db/migrate` — those are schema migrations under `db/migrate/`. These are intent specs.

For full project context (stack, domain model, deploy), see [../CLAUDE.md](../CLAUDE.md).

## Layout

```
code-migrations/
├── code_migrations.yml       # operational index of all migrations
├── intents/                  # *.migration.md — what we plan to do and why
│   └── YYYYMMDDHHMMSS_snake_case_name.migration.md
└── execution/                # <id>.yml — what actually happened (auto-generated)
    └── YYYYMMDDHHMMSS.yml
```

## Naming

- Intent filename: `YYYYMMDDHHMMSS_snake_case_name.migration.md`
  - Example: `20260513093000_configure_sendgrid_smtp.migration.md`
- Always `.migration.md`, never `.rb`. These are specifications, not Ruby code.
- Timestamp portion is the migration id, used everywhere else (index, execution log, commit reference).

## Workflow

See [../docs/WORKFLOW.md](../docs/WORKFLOW.md) for the full operational flow and [../docs/XP_LIFECYCLE.md](../docs/XP_LIFECYCLE.md) for the 9-step XP execution lifecycle.

Short version:
1. Author writes an intent under `intents/` using [../ai/templates/migration.template.md](../ai/templates/migration.template.md).
2. Register it in `code_migrations.yml` with `status: pending`.
3. Run `/run-migrations` — the XP Team (`xp-pair-navigator` → `xp-pair-driver` → `xp-coach-k` + `xp-refactor-techdebt-hunter`) executes it under TDD.
4. On green + DoD pass, an execution record lands in `execution/<id>.yml` and the index is updated.
5. The commit message references the migration id.

## Definition of Done

See [../docs/DOD.md](../docs/DOD.md). A migration is not closed until the DoD passes.
