# frozen_string_literal: true

module Payflow
  class Error < StandardError; end

  class ConfigurationError < Error; end
  class ProviderError < Error; end
  class ProviderNotFoundError < ProviderError; end
  class InvalidWebhookError < Error; end
  class SignatureVerificationError < InvalidWebhookError; end
  class RecordNotFoundError < Error; end
  class SubscriptionError < Error; end
end
