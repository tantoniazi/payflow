# frozen_string_literal: true

module Payflow
  module Webhooks
    class AsaasController < ApplicationController
      def receive
        verifier = SignatureVerifier.new(provider: :asaas, request: request)
        return head :unauthorized unless verifier.valid?

        payload = JSON.parse(request.raw_post)
        WebhookJob.perform_later(provider: :asaas, payload: payload)
        head :ok
      rescue JSON::ParserError
        head :bad_request
      end
    end
  end
end
