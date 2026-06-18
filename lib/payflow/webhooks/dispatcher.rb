# frozen_string_literal: true

module Payflow
  module Webhooks
    class Dispatcher
      PAYMENT_OVERDUE = "PAYMENT_OVERDUE"
      PAYMENT_RECEIVED = "PAYMENT_RECEIVED"
      SUBSCRIPTION_DELETED = "SUBSCRIPTION_DELETED"

      def initialize(webhook_event:)
        @webhook_event = webhook_event
      end

      def dispatch!
        payload = @webhook_event.payload
        event_type = payload["event"]

        case event_type
        when PAYMENT_OVERDUE
          mark_subscription_overdue(payload)
        when PAYMENT_RECEIVED
          mark_subscription_active(payload)
        when SUBSCRIPTION_DELETED
          mark_subscription_cancelled(payload)
        end

        @webhook_event.update!(status: :processed, processed_at: Time.current)
      end

      private

      def find_subscription(payload)
        external_id = payload.dig("payment", "subscription") || payload.dig("subscription", "id")
        return unless external_id

        Subscription.find_by(external_id: external_id)
      end

      def mark_subscription_overdue(payload)
        find_subscription(payload)&.update!(status: :overdue)
      end

      def mark_subscription_active(payload)
        find_subscription(payload)&.update!(status: :active)
      end

      def mark_subscription_cancelled(payload)
        find_subscription(payload)&.update!(status: :cancelled, cancelled_at: Time.current)
      end
    end
  end
end
