# `/docs`

Operational and architectural documentation for this project.

For project context (stack, domain model, deploy commands), see [../CLAUDE.md](../CLAUDE.md) — it is the authoritative source and is not duplicated here.

## Contents

- [WORKFLOW.md](WORKFLOW.md) — operational flow for Code Migrations (selection → execution → DoD → log → commit).
- [DOD.md](DOD.md) — Definition of Done. Base DoD plus project-specific additions.
- [XP_LIFECYCLE.md](XP_LIFECYCLE.md) — the 9-step XP execution lifecycle and the global XP Team agents.
- [adr/](adr/) — Architecture Decision Records.

## ADRs

Architectural decisions are recorded as ADRs under [adr/](adr/). Use [adr/0000-template.md](adr/0000-template.md) as the starting point. Number them sequentially, snake-kebab the title (`0042-switch-from-sqlite-to-postgres.md`).

A decision warrants an ADR when:

- It changes the stack or a load-bearing piece (e.g., the adoption fairness queue, the multi-DB SQLite setup, Kamal deploy).
- It locks in a constraint that future contributors need to understand (e.g., "we deliberately ship without an admin UI for now").
- A reasonable engineer might later wonder "why on earth did we do it this way?"

A decision does **not** warrant an ADR when it's purely cosmetic or scoped to a single migration's implementation detail.
