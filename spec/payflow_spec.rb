# frozen_string_literal: true

require "rails_helper"

RSpec.describe Payflow do
  it "has a version number" do
    expect(Payflow::VERSION).not_to be_nil
  end

  it "resolves configured providers" do
    expect(Payflow.provider(:asaas)).to be_a(Payflow::Providers::Asaas::Client)
    expect(Payflow.provider(:stripe)).to be_a(Payflow::Providers::Stripe::Client)
  end
end
