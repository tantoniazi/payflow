# frozen_string_literal: true

class CreatePayflowSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :payflow_subscriptions do |t|
      t.references :billable, polymorphic: true, null: false, index: true
      t.string :plan, null: false
      t.string :provider, null: false
      t.string :external_id, null: false
      t.string :status, null: false, default: "pending"
      t.datetime :cancelled_at

      t.timestamps
    end

    add_index :payflow_subscriptions, :external_id, unique: true
    add_index :payflow_subscriptions, :status
  end
end
