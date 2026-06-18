class CreatePayflowInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :payflow_invoices do |t|
      t.references :subscription, null: false, foreign_key: { to_table: :payflow_subscriptions }
      t.string :external_id, null: false
      t.string :status, null: false, default: "pending"
      t.decimal :amount, precision: 10, scale: 2
      t.datetime :due_date

      t.timestamps
    end

    add_index :payflow_invoices, :external_id, unique: true
    add_index :payflow_invoices, :status
  end
end
