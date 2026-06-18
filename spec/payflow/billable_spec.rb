# frozen_string_literal: true

require "rails_helper"

RSpec.describe Payflow::Billable do
  let(:organization) { Organization.create!(name: "Acme") }

  before do
    Payflow.configure do |config|
      config.default_provider = :asaas
      config.asaas_api_key = "test_key"
    end

    stub_response = instance_double(Faraday::Response, body: { id: "sub_123" }.to_json)
    client = instance_double(Faraday::Connection)
    allow(Faraday).to receive(:new).and_return(client)
    allow(client).to receive(:post).and_return(stub_response)
    allow(client).to receive(:delete).and_return(stub_response)
  end

  describe "#subscribe!" do
    it "creates an active subscription" do
      subscription = organization.subscribe!(plan: "premium")

      expect(subscription).to be_active
      expect(subscription.plan).to eq("premium")
      expect(subscription.external_id).to eq("sub_123")
    end
  end

  describe "#cancel_subscription!" do
    it "cancels the subscription" do
      organization.subscribe!(plan: "premium")
      subscription = organization.cancel_subscription!

      expect(subscription).to be_cancelled
    end
  end

  describe "#active_subscription?" do
    it "returns true when subscribed" do
      organization.subscribe!(plan: "premium")

      expect(organization).to be_active_subscription
    end
  end
end
