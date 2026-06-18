# frozen_string_literal: true

require "rails_helper"

RSpec.describe Payflow::Subscription do
  let(:organization) { Organization.create!(name: "Acme") }

  subject(:subscription) do
    described_class.create!(
      billable: organization,
      plan: "premium",
      provider: "asaas",
      external_id: "sub_123",
      status: status
    )
  end

  describe "status methods" do
    context "when active" do
      let(:status) { :active }

      it { is_expected.to be_active }
      it { is_expected.not_to be_overdue }
      it { is_expected.not_to be_cancelled }
    end

    context "when overdue" do
      let(:status) { :overdue }

      it { is_expected.not_to be_active }
      it { is_expected.to be_overdue }
      it { is_expected.not_to be_cancelled }
    end

    context "when cancelled" do
      let(:status) { :cancelled }

      it { is_expected.not_to be_active }
      it { is_expected.not_to be_overdue }
      it { is_expected.to be_cancelled }
    end
  end
end
