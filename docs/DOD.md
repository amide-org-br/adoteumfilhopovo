# Definition of Done

A Code Migration is not closed until every item below passes. Coach K enforces this before flipping the migration to `completed` and authorizing the commit.

## Base DoD (applies to every migration)

1. **Code runs without errors.** `bin/rails server` boots; no exceptions in `log/development.log` on the smoke path.
2. **Existing tests pass.** `bin/rails test` is green. If touching system tests, `bin/rails test:system` is green.
3. **New behavior has test coverage.** Every acceptance criterion in the intent maps to at least one test (Minitest + fixtures — no RSpec, no FactoryBot in this repo).
4. **No regression introduced.** The full test suite passes, not just the new tests.
5. **Feature manually validated.** For user-facing changes, a manual smoke check against `bin/dev` (or staging, if applicable).
6. **No obvious technical debt introduced.** Refactor Hunter has scanned post-green. Smells either fixed in-migration or filed as a follow-up migration.

## Project-specific DoD additions

These reflect load-bearing constraints in this codebase. Add to the base DoD when relevant.

- **Adoption fairness queue.** Any change touching `Pna.proximo_da_fila` (in `app/models/pna.rb`) must include tests that pin the three-tier ordering: `total_adocoes ASC → percent_evangelical ASC → population DESC`. The mutation (`total_adocoes += 1; save`) must also be covered.
- **Auth boundary.** New public-facing controllers must declare `skip_before_action :authenticate_user!`. Authenticated controllers must not. A test should assert the expected boundary.
- **Mailer attachments.** Changes to `AdocaoMailer#nova_adocao` must not break the `carta_povo_<pna.id>.png` attachment path. `File.read` has no fallback — a missing card raises at delivery.
- **Multi-DB SQLite.** Schema changes go to the right database (`primary` for app data; cache/queue/cable have their own schemas in `db/cache_schema.rb`, `db/queue_schema.rb`, `db/cable_schema.rb`). Do not cross-write.
- **Frontend bundles.** If touching JS or SCSS, `yarn build` and `yarn build:css` succeed; `app/assets/builds/` is up to date or the change is documented as runtime-only.
- **Deploy parity.** If the migration changes runtime behavior, confirm the `Dockerfile` and `config/deploy.yml` still produce a working `linux/amd64` image. Production runs Kamal → Thruster → Puma; Solid Queue runs in-Puma via `SOLID_QUEUE_IN_PUMA`.

## Out of scope for DoD

- Style nits that don't change behavior (handle in Refactor Hunter's sweep, not DoD).
- Future improvements unrelated to the current intent (file a new migration).
