# frozen_string_literal: true

module Payflow
  module Providers
    module Asaas
      class Webhook
        ASAAS_TOKEN_HEADER = "asaas-access-token"

        def initialize(client)
          @client = client
        end

        def verify_signature(payload:, headers:)
          token = headers[ASAAS_TOKEN_HEADER] || headers[ASAAS_TOKEN_HEADER.upcase]
          expected = @client.send(:credentials)[:webhook_token]
          return false if expected.blank? || token.blank?
          ActiveSupport::SecurityUtils.secure_compare(expected.to_s, token.to_s)
        end

        def parse(payload:, headers: {})
          body = payload.is_a?(String) ? JSON.parse(payload) : payload
          {
            idempotency_key: body["id"] || body.dig("payment", "id"),
            event_type: map_event_type(body["event"]),
            provider: :asaas,
            data: body
          }
        end

        private

        def map_event_type(asaas_event)
          case asaas_event
          when "PAYMENT_RECEIVED" then Payflow::Events::INVOICE_PAID
          when "SUBSCRIPTION_CREATED" then Payflow::Events::SUBSCRIPTION_CREATED
          when "SUBSCRIPTION_DELETED" then Payflow::Events::SUBSCRIPTION_CANCELED
          else asaas_event.to_s.downcase.tr("_", ".")
          end
        end
      end
    end
  end
end
