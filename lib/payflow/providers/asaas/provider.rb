# frozen_string_literal: true

require_relative "customer"
require_relative "subscription"
require_relative "webhook"

module Payflow
  module Providers
    module Asaas
      class Provider < Base
        def initialize
          super(provider_name: :asaas)
        end

        def create_customer(attrs)
          Customer.new(self).create(attrs)
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
