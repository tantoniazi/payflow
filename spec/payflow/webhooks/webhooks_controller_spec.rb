# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Payflow webhooks", type: :request do
  before do
    Payflow.configure do |config|
      config.asaas_webhook_token = "secret_token"
    end
  end

  describe "POST /payflow/webhooks/asaas" do
    let(:payload) { { event: "PAYMENT_RECEIVED", payment: { subscription: "sub_1" } } }

    it "accepts valid webhooks" do
      expect do
        post "/payflow/webhooks/asaas",
             params: payload.to_json,
             headers: {
               "CONTENT_TYPE" => "application/json",
               "asaas-access-token" => "secret_token"
             }
      end.to have_enqueued_job(Payflow::WebhookJob)

      expect(response).to have_http_status(:ok)
      expect(Payflow::WebhookEvent.last).to be_pending
    end

    it "rejects invalid signatures" do
      post "/payflow/webhooks/asaas",
           params: payload.to_json,
           headers: {
             "CONTENT_TYPE" => "application/json",
             "asaas-access-token" => "wrong"
           }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
