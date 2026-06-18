# frozen_string_literal: true

module Payflow
  class WebhooksController < ApplicationController
    def asaas
      verifier = Webhooks::SignatureVerifier.new(provider: :asaas, request: request)

      unless verifier.valid?
        return head :unauthorized
      end

      payload = JSON.parse(request.raw_post)
      event = WebhookEvent.create!(
        provider: "asaas",
        payload: payload,
        status: :pending
      )

      WebhookJob.perform_later(event.id)
      head :ok
    rescue JSON::ParserError
      head :bad_request
    end
  end
end
