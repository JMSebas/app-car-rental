class ModifyInvoicesTable < ActiveRecord::Migration[7.2]
  def change
    # Eliminar la referencia a reservation_id
    remove_reference :invoices, :reservation, foreign_key: true
    
    # Agregar la referencia a rental_id
    add_reference :invoices, :rental, null: false, foreign_key: true

    # Agregar los campos payment_day y actual_payment_day
    add_column :invoices, :payment_day, :date
    add_column :invoices, :actual_payment_day, :date
  end
end
