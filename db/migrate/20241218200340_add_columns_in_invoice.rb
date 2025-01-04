class AddColumnsInInvoice < ActiveRecord::Migration[7.2]
  def change
    add_column :invoices, :amountxDamaged, :decimal
    add_column :invoices, :totalAmount, :decimal
  end
end
