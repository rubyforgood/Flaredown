# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Flaredown is a chronic-illness symptom tracker. It is a monorepo with three deployable apps:

- `backend/` — Rails 8.1 API (Ruby 3.4.10), the only backend for all clients.
- `frontend/` — Ember.js 2.18 web app (the production web client at app.flaredown.com), proxies API calls to the backend.
- `native/` — Expo / React Native + TypeScript app (newer, in-progress replacement for the Ember client).

The root `app/` directory is a stray remnant (single `g-recaptcha.js`), not a fourth app.

## Commands

Everything is Dockerized; `make` wraps `docker compose`. Prefer these over running services natively.

- `make start` / `make stop` — run the full dev stack (backend + workers + Ember frontend) via the `dev` profile.
- `make startNative` / `make stopNative` — run backend + React Native (`native` profile).
- `make build` — rebuild the backend image. Do this before running specs if backend code/deps changed.
- `make seed` — seed databases (`rails app:setup`).
- `make console` — Rails console.
- Web app: http://localhost:4300 (Ember). Native: http://localhost:19006. Backend API: http://localhost:3000.

### Tests

- All backend specs: `make specs` (equivalently `script/backend rspec spec spec`).
- A single spec: `script/backend rspec spec/services/weather_retriever_spec.rb`. The `script/backend` wrapper runs any command inside the backend container (`docker compose --profile dev run --rm backend $@`).
- Add `debugger` to Ruby code to break into an interactive shell under rspec.
- Frontend (Ember): `cd frontend && npm test` (`ember test`).
- Native: `cd native && npm test` (jest), `npm run tsc` (typecheck).

### Lint (all enforced in CI; run before pushing)

- Ruby: `script/backend standardrb` (StandardRB, not RuboCop).
- ERB: `script/backend erb_lint --lint-all`.
- Native: `cd native && npm run lint` (eslint + prettier), `npm run lint:fix` to autofix.

CI (`.github/workflows/{backend,frontend,native}.yml`) uses path filters — backend jobs only run when `backend/**` changes, etc. StandardRB, ERB lint, rspec, and frontend build are required for merge.

## Architecture

### Dual database — the most important thing to understand

The backend uses **both PostgreSQL and MongoDB simultaneously**, split by data type:

- **PostgreSQL (ActiveRecord)** — relational/reference data: `User` (Devise auth), `Condition`, `Symptom`, `Treatment`, `Food`, `Tag`, `Profile`, `Weather`, and the `user_*` join tables. These models subclass `ActiveRecord::Base` and carry a `# == Schema Information` header. Schema lives in `db/schema.rb` + `db/structure.sql`; migrations in `db/migrate/`.
- **MongoDB (Mongoid 9)** — high-volume, user-generated, schemaless data: `Checkin` (the core daily symptom/treatment/tag log), `Comment`, `Reaction`, `Pattern`, `Notification`, `HarveyBradshawIndex`, `Feedback`, `PromotionRate`, `OracleRequest`. These `include Mongoid::Document`. Config in `config/mongoid.yml`.

The two stores are linked by an **encrypted foreign key**: Mongo documents store `encrypted_user_id` (symmetric-encryption gem, see `config/symmetric-encryption.yml`) rather than a plain `user_id`, and dereference it back to the Postgres `User`. When querying check-in data by user, filter on `encrypted_user_id`, not `user_id`. `Checkin` embeds condition/symptom/treatment sub-documents inline.

### API layer

Versioned JSON API under `app/controllers/api/v1/`, routed via `namespace :api { scope module: :v1 }` in `config/routes.rb`. Serialization uses `active_model_serializers` 0.9 (`app/serializers/`). Auth is Devise + `devise_invitable` + Facebook OmniAuth; authorization is CanCanCan with a Mongoid adapter (`app/models/ability.rb`). Business logic lives in `app/services/` (e.g. `weather_retriever`, `pattern_creator`, `chart_list_service`) — controllers should stay thin.

### Background work

Sidekiq (`config/sidekiq.yml`, `worker` process in `Procfile`) backed by Redis, with jobs in `app/jobs/` (check-in reminders, data exports, notification dispatch, top-posts mailers). Recurring schedules are defined in `config/cronotab.rb` (Crono) and rake tasks under `lib/tasks/` invoked by Heroku Scheduler.

### External integrations

Tomorrow.io (weather, via `tomorrowio_rb`), Pusher (realtime), Geocoder + `nearest_time_zone` (location → timezone for reminders), AWS SES (inbound/bounce handling in `aws_ses_controller`).

## Deployment

Heroku, via `rake` tasks in the root `Rakefile`. Frontend and backend are separate Heroku apps deployed with `git subtree split` (`rake production:deploy` / `rake staging:deploy`). Commits to `master` auto-deploy to staging. Postgres/Redis are Heroku addons; MongoDB is hosted at mongodb.com.

## Gotchas

- Node is pinned to **12.22.6** for the Ember frontend (`.tool-versions`); the native app uses a modern toolchain independently. Don't assume one Node version across the repo.
- Env files: `cp backend/env-example backend/.env` and `cp backend/env-example frontend/.env`. A `FACEBOOK_APP_ID` is needed in `frontend/.env` or the app renders a blank beige screen on first load (see README "Common Problems" for the workaround).
