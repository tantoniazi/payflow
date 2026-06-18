# frozen_string_literal: true

module Payflow
  module Webhooks
    class SignatureVerifier
      def initialize(provider:, request:)
        @provider = provider.to_sym
        @request = request
      end

      def valid?
        case @provider
        when :asaas
          verify_asaas
        else
          false
        end
      end

      private

      def verify_asaas
        token = @request.headers["asaas-access-token"]
        expected = Payflow.config.asaas_webhook_token
        return false if token.blank? || expected.blank?

        ActiveSupport::SecurityUtils.secure_compare(token, expected)
      end
    end
  end
end
