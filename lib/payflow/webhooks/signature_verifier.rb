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
        when :stripe
          verify_stripe
        else
          false
        end
      end

      def self.verify_stripe(payload:, signature_header:, secret:)
        return false if secret.blank? || signature_header.blank?

        timestamp, signature = extract_stripe_parts(signature_header)
        return false unless timestamp && signature

        signed_payload = "#{timestamp}.#{payload}"
        expected = OpenSSL::HMAC.hexdigest("SHA256", secret, signed_payload)
        ActiveSupport::SecurityUtils.secure_compare(expected, signature)
      end

      def self.extract_stripe_parts(header)
        parts = header.split(",").to_h { |part| part.split("=", 2) }
        [parts["t"], parts["v1"]]
      end

      private

      def verify_asaas
        token = @request.headers["asaas-access-token"]
        expected = Payflow.config.asaas_webhook_token
        return false if token.blank? || expected.blank?

        ActiveSupport::SecurityUtils.secure_compare(token, expected)
      end

      def verify_stripe
        self.class.verify_stripe(
          payload: @request.raw_post,
          signature_header: @request.headers["HTTP_STRIPE_SIGNATURE"] || @request.headers["Stripe-Signature"],
          secret: Payflow.config.stripe_webhook_secret
        )
      end
    end
  end
end
