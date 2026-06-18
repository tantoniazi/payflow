# frozen_string_literal: true

module Payflow
  module Providers
    module Stripe
      class Subscription
        def initialize(client)
          @client = client
        end

        def create(customer_id:, plan_id:, **options)
          {
            id: "sub_stripe_stub_#{SecureRandom.hex(4)}",
            provider: :stripe,
            customer_id: customer_id,
            plan_id: plan_id,
            status: "active",
            current_period_end: options[:current_period_end]
          }
        end

        def cancel(provider_subscription_id)
          { id: provider_subscription_id, provider: :stripe, status: "canceled" }
        end
      end
    end
  end
end
