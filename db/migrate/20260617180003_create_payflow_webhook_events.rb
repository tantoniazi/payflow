# frozen_string_literal: true

class CreatePayflowWebhookEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :payflow_webhook_events do |t|
      t.string :provider, null: false
      t.json :payload, null: false, default: {}
      t.string :status, null: false, default: "pending"
      t.datetime :processed_at

      t.timestamps
    end

    add_index :payflow_webhook_events, :status
    add_index :payflow_webhook_events, :provider
  end
end
