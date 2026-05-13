# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Stack

- Ruby **3.4.9** (pinned in `.ruby-version` and `mise.toml`), Rails **8.1.3** (Gemfile pins `~> 8.1.0`).
- **SQLite + Solid stack** (Rails 8 defaults): primary, cache (`solid_cache`), queue (`solid_queue`), cable (`solid_cable`). Four SQLite files under `storage/`. No MySQL, no Redis.
- Hotwired (Turbo + Stimulus) with `jsbundling-rails` (esbuild) and `cssbundling-rails` (Dart Sass). Bootstrap 5 + Popper for UI.
- Devise for auth (`User` model). Minitest + fixtures for tests.
- Deploy: **Kamal 2** → `suporte.adoteumfilhopovo.org.br`, Docker Hub registry (`malvins/adoteumfilhopovo`).

> `README.md` is stale (claims Ruby 3.0.0 / Rails 6.1.3). Trust the Gemfile and `.ruby-version`.

## Common commands

```bash
bin/setup                 # bundle install, db:prepare, log/tmp clear, then exec bin/dev
bin/dev                   # foreman -f Procfile.dev: rails server + js watch + css watch
bin/rails server          # web only (use bin/dev for the full stack)

bin/rails db:migrate
bin/rails db:seed         # wipes Adocao/Adotante/Pna, then loads db/AllUnreachedByCountryListing.csv

bin/rails test            # all minitest (models, controllers, mailers, integration)
bin/rails test:system     # capybara/selenium system tests
bin/rails test test/models/pna_test.rb            # single file
bin/rails test test/models/pna_test.rb:42         # single test at line 42

yarn build                # one-shot JS bundle  → app/assets/builds/
yarn build:css            # one-shot CSS bundle → app/assets/builds/application.css

bin/jobs                  # run Solid Queue worker locally (prod runs it in-Puma via SOLID_QUEUE_IN_PUMA)
```

Shell PATH may still resolve to the system Ruby. If you hit "Your Ruby version is X, but your Gemfile specified Y", prefix commands with `mise exec --` (e.g., `mise exec -- bundle exec rails test`).

`Procfile.dev` is for local dev (esbuild/sass `--watch`); the root `Procfile` is unused in production (Kamal runs Thruster → Puma).

## Databases (Rails 8 multi-DB SQLite)

`config/database.yml` defines four connections per environment: `primary`, `cache`, `queue`, `cable`. Files land in `storage/<env>.sqlite3`, `storage/<env>_cache.sqlite3`, etc.

- App data (Pna/Adotante/Adocao/Config/User) is in `primary`.
- `db:prepare` and `db:migrate` route migrations to the right DB based on `migrations_paths` per connection — primary uses `db/migrate/`, the others use the Solid stack's schemas in `db/cache_schema.rb`, `db/queue_schema.rb`, `db/cable_schema.rb`.

## Deploy (Kamal)

Config lives in `config/deploy.yml` + `.kamal/secrets`. To deploy:

```bash
export KAMAL_REGISTRY_PASSWORD=...      # Docker Hub PAT for user `malvins`
# config/master.key must be present locally (gitignored)
bin/kamal setup                          # first time only — bootstraps Docker on the host
bin/kamal deploy
```

Two persistent volumes are mounted on the host:
- `adoteumfilhopovo_storage` → `/rails/storage` (all four SQLite DBs + ActiveStorage).
- `adoteumfilhopovo_prayer_cards` → `/rails/app/assets/images/prayer_cards` (the 7,408 PNGs are not in the image — rsync them to the host volume path).

After the first deploy, the entrypoint runs `db:prepare` but **not** `db:seed`. Run seed manually:
```bash
bin/kamal app exec 'bin/rails db:seed'
```

`Dockerfile` builds for `linux/amd64` via `builder.arch: amd64` (Apple Silicon dev → amd64 VPS). `BUNDLE_WITHOUT="development:test"` is set; `rmagick` (in `:development, :test`) needs ImageMagick and is excluded from the slim runtime image.

## Architecture

This is the **Adote um Filho Povo** (AMIDE) site: visitors "adopt" an unreached people group (PNA — *Povo Não Alcançado*) for prayer, and the system emails them a prayer card. Data comes from Joshua Project's `AllUnreachedByCountryListing.csv`.

### Domain model (all Portuguese names)

- `Pna` — a people group. Big denormalized record sourced from the Joshua Project CSV (population, religion, JP scale, photo/flag URLs, lat/long, etc.) plus `total_adocoes` counter and `has_invalid_*_url` flags.
- `Adotante` — the adopter (name, state, email, phone, prayer request, commitment checkbox).
- `Adocao` — join row between `Pna` and `Adotante` with `data_adocao`.
- `Config`, `Estado`, `User` (Devise).

### Adoption queue — the load-bearing piece

`Pna.proximo_da_fila` (in `app/models/pna.rb`) picks the next PNA to assign by ordering:
1. `total_adocoes ASC` (least-adopted first),
2. then `percent_evangelical ASC` (least-evangelized first),
3. then `population DESC`.

It **mutates** the chosen `Pna` (`total_adocoes += 1; save`) before returning it. Any change to assignment fairness or the queue ordering goes here. The flow is driven from `WebsiteController#create`:

```
Adotante.save → Pna.proximo_da_fila → adotante.adotar(pna)
              → AdocaoMailer.nova_adocao(...).deliver_later
```

### Auth boundary

`ApplicationController` calls `before_action :authenticate_user!` globally (Devise). The public landing-page flow in `WebsiteController` opts out with `skip_before_action :authenticate_user!`. New public-facing controllers must do the same; everything else inherits the authenticated default.

### Mailer relies on pre-rendered prayer cards

`AdocaoMailer#nova_adocao` attaches `app/assets/images/prayer_cards/carta_povo_<pna.id>.png`. The file is read with `File.read` (no fallback), so a missing card for a given `Pna.id` will raise at delivery time. In dev, `./prayer_cards` symlinks to a local source of 7,408 cards. In prod, the Kamal volume `adoteumfilhopovo_prayer_cards` holds them.

### Frontend pipeline

- JS entry: `app/javascript/application.js` → esbuild → `app/assets/builds/*.js`. Stimulus controllers live under `app/javascript/controllers/`.
- CSS entry: `app/assets/stylesheets/application.scss` → Dart Sass (`--load-path=node_modules`) → `app/assets/builds/application.css`. Bootstrap is pulled from `node_modules`.
- The `Dockerfile` runs `yarn build` + `yarn build:css` before `assets:precompile` so the built files exist when Sprockets fingerprints them.

### Routes

Tiny, defined in `config/routes.rb`: `devise_for :users`, `resources :adocaos / :adotantes / :website`, an extra `get 'website/adoption'`, and `root → website#index`. (The `website/adoption` route has no matching action — pre-existing.)
