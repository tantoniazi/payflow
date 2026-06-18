# frozen_string_literal: true

module Payflow
  class ProviderResolver
    REGISTRY = {
      asaas: Providers::Asaas::Provider,
      stripe: Providers::Stripe::Provider
    }.freeze

    def self.for(name)
      key = name.to_sym
      klass = REGISTRY[key]
      raise ProviderNotFoundError, "Unknown provider: #{key}" unless klass

      klass.new
    end
  end
end
