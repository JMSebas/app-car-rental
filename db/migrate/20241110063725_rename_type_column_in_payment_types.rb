class RenameTypeColumnInPaymentTypes < ActiveRecord::Migration[7.2]
  def change
    rename_column :payment_types, :type, :payment_method
  end
end
