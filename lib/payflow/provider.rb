# frozen_string_literal: true

module Payflow
  module Provider
    REGISTRY = {
      asaas: Payflow::Providers::Asaas::Client,
      stripe: Payflow::Providers::Stripe::Client
    }.freeze

    def self.resolve(name = nil)
      key = (name || Payflow.config.default_provider).to_sym
      klass = REGISTRY[key]
      raise ProviderNotFoundError, "Unknown provider: #{key}" unless klass

      klass.new
    end
  end
end
