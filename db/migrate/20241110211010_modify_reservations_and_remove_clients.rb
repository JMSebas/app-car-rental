class ModifyReservationsAndRemoveClients < ActiveRecord::Migration[7.2]
  def change
    # Modificar la tabla reservations
    change_table :reservations do |t|
      # Eliminar la referencia a client_id y rate_id
      t.remove_references :client, foreign_key: true
      t.remove_references :rate, foreign_key: true
      
      # Eliminar el campo car_status
      t.remove :car_status
    end

    # Eliminar la tabla clients
    drop_table :clients, if_exists: true
  end
end
