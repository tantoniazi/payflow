# frozen_string_literal: true

module Payflow
  module Providers
    module Stripe
      class Webhook
        def initialize(client)
          @client = client
        end

        def verify_signature(payload:, headers:)
          Payflow::Webhooks::SignatureVerifier.verify_stripe(
            payload: payload,
            signature_header: headers["HTTP_STRIPE_SIGNATURE"] || headers["Stripe-Signature"],
            secret: @client.send(:credentials)[:webhook_secret]
          )
        end

        def parse(payload:, headers: {})
          body = payload.is_a?(String) ? JSON.parse(payload) : payload
          {
            idempotency_key: body["id"],
            event_type: body["type"],
            provider: :stripe,
            data: body.dig("data", "object") || {}
          }
        end
      end
    end
  end
end
