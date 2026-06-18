# frozen_string_literal: true

module Payflow
  class WebhookJob < ApplicationJob
    queue_as :payflow

    def perform(webhook_event_id)
      event = WebhookEvent.find(webhook_event_id)
      Webhooks::Dispatcher.new(webhook_event: event).dispatch!
      event.update!(status: :processed, processed_at: Time.current)
    rescue StandardError
      event&.update!(status: :failed)
      raise
    end
  end
end
