# frozen_string_literal: true

Payflow.configure do |config|
  config.default_provider = :asaas

  config.asaas_api_key = ENV.fetch("ASAAS_API_KEY", nil)
  config.asaas_webhook_token = ENV.fetch("ASAAS_WEBHOOK_TOKEN", nil)

  config.stripe_api_key = ENV.fetch("STRIPE_API_KEY", nil)
  config.stripe_webhook_secret = ENV.fetch("STRIPE_WEBHOOK_SECRET", nil)

  # config.billable_class_name = "Organization"
end
