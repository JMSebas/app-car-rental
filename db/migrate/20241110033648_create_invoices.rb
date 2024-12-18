class CreateInvoices < ActiveRecord::Migration[7.2]
  def change
    create_table :invoices do |t|
      t.references :reservation, null: false, foreign_key: true
      t.references :payment_type, null: false, foreign_key: true
      t.decimal :tax

      t.timestamps
    end
  end
end
