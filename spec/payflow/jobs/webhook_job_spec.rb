# frozen_string_literal: true

require "rails_helper"

RSpec.describe Payflow::WebhookJob do
  let(:organization) { Organization.create!(name: "Acme") }
  let!(:subscription) do
    Payflow::Subscription.create!(
      billable: organization,
      plan: "premium",
      provider: "asaas",
      external_id: "sub_ext_123",
      status: :active
    )
  end

  let(:payload) do
    {
      "event" => "PAYMENT_OVERDUE",
      "payment" => { "subscription" => "sub_ext_123" }
    }
  end

  it "processes the webhook and marks subscription overdue" do
    described_class.perform_now(provider: :asaas, payload: payload)

    event = Payflow::WebhookEvent.last
    expect(event).to be_processed
    expect(subscription.reload).to be_overdue
  end
end
