# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Payflow webhooks", type: :request do
  before do
    Payflow.configure do |config|
      config.asaas_webhook_token = "secret_token"
      config.stripe_webhook_secret = "whsec_test"
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
      end.to have_enqueued_job(Payflow::WebhookJob).with(
        hash_including(provider: :asaas, payload: hash_including("event" => "PAYMENT_RECEIVED"))
      )

      expect(response).to have_http_status(:ok)
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

  describe "POST /payflow/webhooks/stripe" do
    let(:payload) { { id: "evt_1", type: "invoice.paid", data: { object: {} } } }
    let(:raw_payload) { payload.to_json }
    let(:timestamp) { Time.now.to_i }
    let(:signature) do
      signed = "#{timestamp}.#{raw_payload}"
      "t=#{timestamp},v1=#{OpenSSL::HMAC.hexdigest('SHA256', 'whsec_test', signed)}"
    end

    it "accepts valid webhooks" do
      expect do
        post "/payflow/webhooks/stripe",
             params: raw_payload,
             headers: {
               "CONTENT_TYPE" => "application/json",
               "Stripe-Signature" => signature
             }
      end.to have_enqueued_job(Payflow::WebhookJob)

      expect(response).to have_http_status(:ok)
    end

    it "rejects invalid signatures" do
      post "/payflow/webhooks/stripe",
           params: raw_payload,
           headers: {
             "CONTENT_TYPE" => "application/json",
             "Stripe-Signature" => "t=0,v1=invalid"
           }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
