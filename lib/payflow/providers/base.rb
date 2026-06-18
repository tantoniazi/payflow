# frozen_string_literal: true

module Payflow
  module Providers
    class Base
      attr_reader :provider_name

      def initialize(provider_name:)
        @provider_name = provider_name.to_sym
      end

      def create_customer(attrs)
        raise NotImplementedError, "#{self.class}##{__method__}"
      end

      def find_customer(provider_customer_id)
        raise NotImplementedError, "#{self.class}##{__method__}"
      end

      def create_subscription(customer_id:, plan_id:, **options)
        raise NotImplementedError, "#{self.class}##{__method__}"
      end

      def cancel_subscription(provider_subscription_id)
        raise NotImplementedError, "#{self.class}##{__method__}"
      end

      def find_subscription(provider_subscription_id)
        raise NotImplementedError, "#{self.class}##{__method__}"
      end

      def list_invoices(provider_subscription_id:)
        raise NotImplementedError, "#{self.class}##{__method__}"
      end

      def verify_webhook_signature(payload:, headers:)
        raise NotImplementedError, "#{self.class}##{__method__}"
      end

      def parse_webhook(payload:, headers: {})
        raise NotImplementedError, "#{self.class}##{__method__}"
      end

      protected

      def credentials
        Payflow.config.provider_credentials(provider_name)
      end
    end
  end
end
