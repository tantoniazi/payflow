# frozen_string_literal: true

module Payflow
  class OverdueCheckJob < ApplicationJob
    queue_as :payflow

    def perform
      Subscription.active.find_each do |subscription|
        latest_invoice = subscription.invoices.order(created_at: :desc).first
        next unless latest_invoice&.overdue?

        subscription.update!(status: :overdue)
      end
    end
  end
end
