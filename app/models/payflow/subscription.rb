# frozen_string_literal: true

module Payflow
  class Subscription < ApplicationRecord
    self.table_name = "payflow_subscriptions"

    belongs_to :billable, polymorphic: true
    has_many :invoices, class_name: "Payflow::Invoice", dependent: :destroy

    enum :status, {
      pending: "pending",
      active: "active",
      overdue: "overdue",
      cancelled: "cancelled"
    }

    validates :plan, :provider, :external_id, presence: true

    def active?
      status == "active"
    end

    def overdue?
      status == "overdue"
    end

    def cancelled?
      status == "cancelled"
    end
  end
end
