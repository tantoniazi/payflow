# frozen_string_literal: true

module Payflow
  class SubscriptionService
    def initialize(billable:)
      @billable = billable
    end

    def subscribe!(plan:, provider: Payflow.config.provider)
      current = @billable.subscription
      raise SubscriptionError, "Already subscribed" if current&.active?

      client = Payflow.provider(provider)
      remote = client.create_subscription(
        customer_id: customer_id_for(@billable),
        plan_id: plan
      )

      Subscription.create!(
        billable: @billable,
        plan: plan,
        provider: provider.to_s,
        external_id: remote[:id],
        status: :active
      )
    end

    def cancel!
      subscription = @billable.subscription
      raise SubscriptionError, "No active subscription" unless subscription

      client = Payflow.provider(subscription.provider.to_sym)
      client.cancel_subscription(subscription.external_id)
      subscription.update!(status: :cancelled, cancelled_at: Time.current)
      subscription
    end

    private

    def customer_id_for(billable)
      if billable.respond_to?(:payflow_provider_customer_id)
        billable.payflow_provider_customer_id
      else
        "cus_#{billable.class.name.underscore}_#{billable.id}"
      end
    end
  end
end
