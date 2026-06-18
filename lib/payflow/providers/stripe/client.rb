# frozen_string_literal: true

require_relative "subscription"
require_relative "webhook"

module Payflow
  module Providers
    module Stripe
      class Client < Base
        def initialize
          super(provider_name: :stripe)
        end

        def create_customer(attrs)
          { id: "cus_stripe_stub_#{SecureRandom.hex(4)}", provider: :stripe, email: attrs[:email], name: attrs[:name] }
        end

        def create_subscription(customer_id:, plan_id:, **options)
          Subscription.new(self).create(customer_id: customer_id, plan_id: plan_id, **options)
        end

        def cancel_subscription(provider_subscription_id)
          Subscription.new(self).cancel(provider_subscription_id)
        end

        def list_invoices(provider_subscription_id:)
          []
        end

        def verify_webhook_signature(payload:, headers:)
          Webhook.new(self).verify_signature(payload: payload, headers: headers)
        end

        def parse_webhook(payload:, headers: {})
          Webhook.new(self).parse(payload: payload, headers: headers)
        end
      end
    end
  end
end
