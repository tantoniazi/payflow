# frozen_string_literal: true

module Payflow
  module Billable
    extend ActiveSupport::Concern

    included do
      has_many :payflow_subscriptions,
               as: :billable,
               class_name: "Payflow::Subscription",
               dependent: :destroy
    end

    def subscribe!(plan:, provider: Payflow.config.provider)
      SubscriptionService.new(billable: self).subscribe!(plan: plan, provider: provider)
    end

    def cancel_subscription!
      SubscriptionService.new(billable: self).cancel!
    end

    def subscription
      payflow_subscriptions.order(created_at: :desc).first
    end

    def active_subscription?
      subscription&.active?
    end

    def can_access_system?
      active_subscription? && !subscription&.overdue?
    end
  end
end
