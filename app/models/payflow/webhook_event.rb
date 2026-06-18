# frozen_string_literal: true

module Payflow
  class WebhookEvent < ApplicationRecord
    self.table_name = "payflow_webhook_events"

    enum :status, {
      pending: "pending",
      processed: "processed",
      failed: "failed"
    }

    validates :provider, :payload, presence: true
  end
end
