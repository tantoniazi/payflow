# Payflow

Unified multi-provider billing system for Rails (Asaas, Stripe, Mercado Pago, Pagar.me).

## Installation

Add to your Gemfile:

```ruby
gem "payflow"
```

Run:

```bash
bundle install
rails payflow:install:migrations
rails db:migrate
```

## Configuration

```ruby
# config/initializers/payflow.rb
Payflow.configure do |config|
  config.default_provider = :asaas
  config.asaas_api_key = ENV["ASAAS_API_KEY"]
  config.asaas_webhook_token = ENV["ASAAS_WEBHOOK_TOKEN"]
  config.stripe_api_key = ENV["STRIPE_API_KEY"]
end
```

Mount the engine in `config/routes.rb`:

```ruby
mount Payflow::Engine, at: "/payflow"
```

## Usage

Include `Payflow::Billable` in your host model:

```ruby
class Organization < ApplicationRecord
  include Payflow::Billable
end
```

```ruby
organization.subscribe!(plan: "premium")
organization.cancel_subscription!
organization.subscription.active?
organization.subscription.overdue?
organization.subscription.cancelled?
```

## Webhooks

Asaas webhooks are received at `POST /payflow/webhooks/asaas`.

## License

MIT
