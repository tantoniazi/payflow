# frozen_string_literal: true

module Payflow
  module Providers
    module Asaas
      class Subscription
        BASE_URL = "https://api.asaas.com/v3"

        def initialize(client)
          @client = client
        end

        def create(customer_id:, plan_id:, **)
          response = http_client.post("/subscriptions") do |req|
            req.body = {
              customer: customer_id,
              billingType: "CREDIT_CARD",
              value: plan_value(plan_id),
              cycle: "MONTHLY",
              description: "Plan #{plan_id}"
            }.to_json
          end

          data = JSON.parse(response.body)
          { id: data["id"], provider: :asaas, status: "active" }
        end

        def cancel(provider_subscription_id)
          http_client.delete("/subscriptions/#{provider_subscription_id}")
          { id: provider_subscription_id, provider: :asaas, status: "cancelled" }
        end

        private

        def http_client
          @http_client ||= Faraday.new(url: BASE_URL) do |f|
            f.request :json
            f.response :raise_error
            f.headers["access_token"] = @client.send(:credentials)[:api_key]
            f.headers["Content-Type"] = "application/json"
          end
        end

        def plan_value(plan)
          { "basic" => 29.90, "premium" => 99.90 }[plan.to_s] || 49.90
        end
      end
    end
  end
end
