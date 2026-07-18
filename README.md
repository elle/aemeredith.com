# aemeredith.com

Elle Meredith's personal site. A small [Sinatra](https://sinatrarb.com) app with
three sections:

- **Home** — bio, testimonials, work values, talks.
- **Articles** — writing, rendered from Markdown files in `posts/`.
- **Elle Bread** — a weekly bakery order form backed by PostgreSQL, with an admin
  area for choosing the week's breads and reviewing orders.

## Stack

- Ruby 3.4.2 (see `.ruby-version`)
- Sinatra + [sinatra-activerecord](https://github.com/sinatra-activerecord/sinatra-activerecord)
- PostgreSQL via ActiveRecord
- Haml templates, Sass stylesheets, Kramdown for Markdown
- Mail for order notifications
- RSpec + Rack::Test

## Setup

```sh
bundle install
bundle exec rake db:create db:migrate
```

The test database is set up the same way with `RACK_ENV=test`:

```sh
RACK_ENV=test bundle exec rake db:create db:migrate
```

Copy the environment template and fill in local values:

```sh
cp .env.example .env
```

In development and test, [dotenv](https://github.com/bkeepers/dotenv) loads `.env`
automatically. `.env` is git-ignored; production reads real environment variables.

## Running

```sh
bundle exec foreman start -f Procfile.dev   # web process only
# or
bundle exec ruby app.rb
```

The root `Procfile` is for Heroku and includes a `release` migration step,
so use `Procfile.dev` locally to run just the web process.

## Content

Articles are Markdown files in `posts/`, one per article, with `title` and
`date` frontmatter:

```markdown
---
title: Slow is smooth, smooth is fast
date: 2026-06-11
description: A short summary used in listings.
---

Article body in Markdown…
```

Home-page data lives in `data/talks.yml` and `data/testimonials.yml`. The Elle
Bread catalogue lives in `data/breads.yml`.

## Elle Bread

The public order form shows the three breads the admin has selected for the
current week. Placing an order writes to the `orders` / `order_items` tables and
emails a notification to the site owner.

The admin area (`/bread/admin`) is gated by a single password and lets you
pick the week's three breads and review order history. Orders carry a `status`
column (defaulting to `unpaid`) as a seam for future payment integration.

## Environment variables

| Variable | Purpose |
|---|---|
| `DATABASE_URL` | Postgres connection string (production) |
| `SESSION_SECRET` | Secret for signed session cookies |
| `ADMIN_PASSWORD` | Password for the Elle Bread admin area |
| `ORDER_RECIPIENT` | Where order notifications are sent (defaults to `elle@aemeredith.com`) |
| `MAIL_FROM` | From address for notifications (defaults to `orders@aemeredith.com`) |
| `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD` | SMTP delivery (production) |

In development, mail is written to the log rather than sent.

## Tests

```sh
bundle exec rspec
```

Specs that touch the database are tagged `:db` and run inside a transaction that
rolls back after each example.
