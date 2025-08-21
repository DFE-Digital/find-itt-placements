# Readme

# Find ITT Placements

> A Ruby on Rails application that allows **schools** to publish their placement preferences and **providers** to find schools that are open to, or intersted in hosting placements to facilitate more placements across the initial teacher training (ITT) market.

This service has different interfaces for schools and providers, whilst also allowing users with affiliations to multiple organisation types to switch between their organisations.

## Table of contents

* [Overview](#overview)
* [Architecture](#architecture)
* [Tech stack](#tech-stack)
* [Requirements](#requirements)
* [Setup](#setup)

  * [Prerequisites](#prerequisites)
  * [asdf toolchain](#asdf-toolchain)
  * [Environment variables](#environment-variables)
  * [Database](#database)
  * [Node & assets](#node--assets)
* [Running the app](#running-the-app)
* [Authentication](#authentication)
* [Testing](#testing)

  * [Linting & static analysis](#linting--static-analysis)

  * [Intellisense](#intellisense)
* [Docs & ADRs](#docs--adrs)

---

## Overview

This service enables **providers** to find  **schools** with **placements**  based on the preferences that they list on the service.

* **School interface**: create and manage placement preferences, set dates/subjects/locations.
* **Provider interface**: find schools who the provider may want to work with.

## Architecture

* Rails **8.0.2** app (API+server-rendered views) using the **GOV.UK Design System** via `govuk-components` and `govuk_design_system_formbuilder`.
* Two “service contexts”: **schools** and **providers** with distinct navigation and controllers.
* Database-backed **sessions** (`activerecord-session_store`).
* **Solid Queue** for background jobs; **Mission Control Jobs** UI for observability.
* **Solid Cache** (DB-backed) for Rails.cache.
* Geocoding by **geocoder** (e.g. for location-based search).

## Tech stack

* **Ruby**: *3.4.1* (managed via asdf)
* **Rails**: 8.0.2
* **DB**: PostgreSQL (tested with **17.2**)
* **Job queue**: `solid_queue`
* **Cache**: `solid_cache`
* **Auth**: OmniAuth OpenID Connect (DfE Sign-in)
* **Assets**: `jsbundling-rails` + `cssbundling-rails` (Node + Yarn), `propshaft`
* **HTTP**: `httparty`
* **Pagination**: `pagy`
* **Presentation**: `draper`
* **Logging**: `rails_semantic_logger`
* **Deployment**: `kamal`

## Requirements

* Postgres **17.x** (server + headers)
* NodeJS **≥ 18** and Yarn (via asdf)
* Build tools (for native gems)

> macOS users: install `asdf` via Homebrew; Linux users: follow asdf docs.

## Setup

### Prerequisites

This project depends on:

* [Ruby](https://www.ruby-lang.org/)
* [Ruby on Rails](https://rubyonrails.org/)
* [NodeJS](https://nodejs.org/)
* [Yarn](https://yarnpkg.com/)
* [PostgreSQL](https://www.postgresql.org/)

### asdf toolchain

Install the required tools and then install versions pinned in `.tool-versions`:

```sh
brew install asdf # on macOS
asdf plugin add ruby
asdf plugin add nodejs
asdf plugin add yarn
asdf plugin add postgres
asdf install
```

When installing the `pg` gem, Bundler executes outside the project directory and can miss the pinned Postgres version. To ensure `pg` compiles correctly use:

```sh
ASDF_POSTGRES_VERSION=17.2 bundle install
```

### Environment variables

We use `dotenv-rails` in development and test. Create a `.env` file (not committed):

```dotenv
SIGN_IN_METHOD=persona
#SIGN_IN_METHOD=dfe-sign-in

APP_BASE_URL=localhost:3000

#DFE Sign in config
DFE_SIGN_IN_ISSUER_URL=https://dev-oidc.signin.education.gov.uk
DFE_SIGN_IN_CLIENT_ID=ittMentorSchoolPlacement
DFE_SIGN_IN_SECRET=TBD
GIAS_CSV_BASE_URL=https://ea-edubase-api-prod.azurewebsites.net/edubase/downloads/public

SOLID_QUEUE_IN_PUMA=true
```

### Database

Create and seed the database:

```sh
bin/setup
# or 
bundle exec rails db:create db:migrate db:seed
```

### Node & assets

Install JS and CSS dependencies and build once:

```sh
yarn install
bin/rails assets:precompile # optional for dev; `bin/dev` will build on the fly
```

## Running the app

For local development we recommend `bin/dev` (Procfile-based) which runs Rails, JS and CSS watchers together:

```sh
bin/dev
```

The app should be available at **[http://localhost:3000](http://localhost:3000)**.

## Authentication

We use **DfE Sign-in** via **OmniAuth OpenID Connect**. Currently we sign in with personas in development; DfE-Sign in will be implemented in future.

## Testing

We use **RSpec** with **Capybara** and **Selenium WebDriver** for system tests.

```sh
bundle exec rspec
```

Useful notes:

* Screenshots on failure are saved by `capybara-screenshot`.
* Time-sensitive tests use `timecop`.
* External requests are stubbed with `webmock`.
* Controller specs are enabled via `rails-controller-testing`.

### Linting & static analysis

* Ruby style: `rubocop-rails-omakase`
* ERB templates: `erb_lint`
* Security scanner: `brakeman`

```sh
bin/lint
```

### Intellisense

We bundle `solargraph` + `solargraph-rails`. After installing, index your bundle:

```sh
bin/bundle exec yard gems
```

VS Code setting:

```json
{
  "solargraph.useBundler": true
}
```

## Docs & ADRs

We keep Architecture Decision Records in [`/adr`](adr/). Generate a new ADR with:

```sh
bin/bundle exec rladr new "Title of the decision"
```
