# frozen_string_literal: true

module Payflow
  class Configuration
    attr_accessor :provider,
                  :asaas_api_key,
                  :asaas_webhook_token,
                  :stripe_api_key,
                  :stripe_webhook_secret,
                  :billable_class_name

    alias default_provider provider
    alias default_provider= provider=

    def initialize
      @provider = :asaas
      @billable_class_name = nil
    end

    def provider_credentials(provider_name)
      case provider_name.to_sym
      when :asaas
        { api_key: asaas_api_key, webhook_token: asaas_webhook_token }
      when :stripe
        { api_key: stripe_api_key, webhook_secret: stripe_webhook_secret }
      else
        raise ProviderNotFoundError, "Unknown provider: #{provider_name}"
      end
    end
  end
end
