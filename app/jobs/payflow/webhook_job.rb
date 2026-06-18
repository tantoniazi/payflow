# frozen_string_literal: true

module Payflow
  class WebhookJob < ApplicationJob
    queue_as :payflow

    def perform(provider:, payload:)
      event = WebhookEvent.create!(
        provider: provider.to_s,
        payload: payload,
        status: :pending
      )

      Webhooks::Dispatcher.new(webhook_event: event).dispatch!
      event.update!(status: :processed, processed_at: Time.current)
    rescue StandardError
      event&.update!(status: :failed)
      raise
    end
  end
end
