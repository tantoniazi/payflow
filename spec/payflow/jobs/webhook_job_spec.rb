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

  let(:webhook_event) do
    Payflow::WebhookEvent.create!(
      provider: "asaas",
      payload: {
        "event" => "PAYMENT_OVERDUE",
        "payment" => { "subscription" => "sub_ext_123" }
      },
      status: :pending
    )
  end

  it "processes the webhook and marks subscription overdue" do
    described_class.perform_now(webhook_event.id)

    expect(webhook_event.reload).to be_processed
    expect(subscription.reload).to be_overdue
  end
end
