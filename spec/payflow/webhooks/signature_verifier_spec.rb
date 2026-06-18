# frozen_string_literal: true

require "rails_helper"

RSpec.describe Payflow::Webhooks::SignatureVerifier do
  let(:request) { instance_double(ActionDispatch::Request, headers: headers) }
  let(:headers) { { "asaas-access-token" => "secret_token" } }

  before do
    Payflow.configure do |config|
      config.asaas_webhook_token = "secret_token"
    end
  end

  subject(:verifier) { described_class.new(provider: :asaas, request: request) }

  describe "#valid?" do
    it "returns true for matching token" do
      expect(verifier).to be_valid
    end

    context "with invalid token" do
      let(:headers) { { "asaas-access-token" => "wrong" } }

      it "returns false" do
        expect(verifier).not_to be_valid
      end
    end

    context "with missing token" do
      let(:headers) { {} }

      it "returns false" do
        expect(verifier).not_to be_valid
      end
    end
  end
end
