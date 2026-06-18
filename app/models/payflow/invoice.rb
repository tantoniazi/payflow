# frozen_string_literal: true

module Payflow
  class Invoice < ApplicationRecord
    self.table_name = "payflow_invoices"

    belongs_to :subscription, class_name: "Payflow::Subscription"

    enum :status, {
      pending: "pending",
      paid: "paid",
      overdue: "overdue",
      cancelled: "cancelled"
    }

    validates :external_id, presence: true
  end
end
