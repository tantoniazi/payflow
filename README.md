# Payflow

[![CI](https://github.com/tantoniazi/payflow/actions/workflows/ci.yml/badge.svg)](https://github.com/tantoniazi/payflow/actions/workflows/ci.yml)
[![Release](https://github.com/tantoniazi/payflow/actions/workflows/release.yml/badge.svg)](https://github.com/tantoniazi/payflow/actions/workflows/release.yml)

Unified billing engine for Rails applications. Payflow abstracts subscription management and payment webhooks behind a provider-agnostic API.

**MVP 0.1.0 providers:** Asaas (functional), Stripe (basic).

Mercado Pago and Pagar.me are on the [roadmap](ROADMAP.md) — not included in this release.

## Installation

Add to your Gemfile:

```ruby
gem "payflow"
```

Then run:

```bash
bundle install
rails generate payflow:install
rails db:migrate
```

Alternatively, copy engine migrations without the generator:

```bash
rails payflow:install:migrations
rails db:migrate
```

## Setup

Create `config/initializers/payflow.rb` (or use the generator output):

```ruby
Payflow.configure do |config|
  config.provider = :asaas

  config.asaas_api_key = ENV["ASAAS_API_KEY"]
  config.asaas_webhook_token = ENV["ASAAS_WEBHOOK_TOKEN"]

  config.stripe_api_key = ENV["STRIPE_API_KEY"]
  config.stripe_webhook_secret = ENV["STRIPE_WEBHOOK_SECRET"]
end
```

Mount the engine in `config/routes.rb`:

```ruby
mount Payflow::Engine => "/payflow"
```

## Usage

Include `Payflow::Billable` in your host model:

```ruby
class Organization < ApplicationRecord
  include Payflow::Billable
end
```

Subscribe and manage billing:

```ruby
organization.subscribe!(plan: "premium", provider: Payflow.config.provider)
organization.cancel_subscription!
organization.active_subscription?
organization.can_access_system?  # active and not overdue
```

## Webhooks

Configure your payment providers to send webhooks to:

| Provider | Endpoint |
|----------|----------|
| Asaas    | `POST /payflow/webhooks/asaas` |
| Stripe   | `POST /payflow/webhooks/stripe` |

Webhooks are verified, persisted as `Payflow::WebhookEvent` records, and processed asynchronously via `Payflow::WebhookJob` and Sidekiq (`:payflow` queue).

## Architecture

```
Host App
  └── Payflow::Engine (mounted at /payflow)
        ├── Payflow::Billable concern
        ├── Models: Subscription, Invoice, WebhookEvent
        ├── Jobs: WebhookJob, OverdueAccountsJob
        ├── Payflow::ProviderResolver
        │     ├── Providers::Asaas::Provider
        │     └── Providers::Stripe::Provider
        └── Webhooks::Dispatcher
```

- **Billable** — polymorphic `billable` association on subscriptions
- **ProviderResolver** — `Payflow::ProviderResolver.for(:asaas)` returns the provider client
- **WebhookJob** — receives `provider` + `payload`, dispatches to update subscription/invoice state

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Releasing

See [RELEASE.md](RELEASE.md) for the RubyGems publishing checklist.

## License

MIT — Copyright (c) Conexus Systems. See [LICENSE](LICENSE).
