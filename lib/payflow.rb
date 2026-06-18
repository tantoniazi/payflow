# frozen_string_literal: true

require "rails"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "faraday"
require "sidekiq"

require "payflow/version"
require "payflow/errors"
require "payflow/events"
require "payflow/configuration"
require "payflow/providers/base"
require "payflow/providers/asaas/provider"
require "payflow/providers/stripe/provider"
require "payflow/provider_resolver"
require "payflow/subscription_service"
require "payflow/billable"
require "payflow/webhooks/signature_verifier"
require "payflow/webhooks/dispatcher"
require "payflow/engine"

module Payflow
  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield config if block_given?
      config
    end

    def provider(name = nil)
      ProviderResolver.for(name || config.provider)
    end
  end
end
