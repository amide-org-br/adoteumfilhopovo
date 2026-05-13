# `/ai` — AI Engineering Conventions

Operational conventions for AI-assisted work in this repository. Project context (stack, domain, deploy) lives in [../CLAUDE.md](../CLAUDE.md) — this directory is for **how we work**, not what the project is.

## Layout

```
ai/
├── agents/       # project-local agent role notes (overrides/extensions of global agents)
├── playbooks/    # repeatable procedures (deploy, seed, hotfix, etc.)
└── templates/    # scaffolding templates for migrations, execution logs, ADRs
```

## Global XP Team

These agents are installed globally and operate on this repo without local definitions:

- `project-setupper` — bootstraps the operational structure (this directory tree).
- `xp-pair-navigator` — reads migration intent, plans the smallest next step.
- `xp-pair-driver` — implements in TDD, tiny increments.
- `xp-coach-k` — validates XP discipline; closes the migration.
- `xp-refactor-techdebt-hunter` — scans for smells after green.

Trigger them via `/run-migrations` (or any natural variant). Do not spawn them speculatively.

## Project-local extensions

Add project-specific role notes under `agents/` only when global behavior needs to be overridden or extended for this codebase. Examples that would belong here:

- Constraints around `Pna.proximo_da_fila` (the load-bearing fairness queue).
- Auth boundary reminders (`ApplicationController` has `authenticate_user!` globally; public-facing controllers must `skip_before_action`).
- Test conventions (Minitest + fixtures, not RSpec/FactoryBot).

Add to `playbooks/` for repeatable operational sequences (e.g., "first-deploy DNS cutover", "rsync prayer_cards to host volume").

## Principles (XP, Kent Beck)

- Pair programming (Navigator + Driver).
- TDD — red, green, refactor.
- Incremental delivery; smallest possible step.
- Continuous refactoring after green.
- Simplicity first. No speculative abstraction.
- DoD enforced before commit.
