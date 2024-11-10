class DroppTbles < ActiveRecord::Migration[7.2]
  def change
    drop_table :damages, if_exists: true
    drop_table :invoices, if_exists: true
    drop_table :maintenances, if_exists: true
    drop_table :payments, if_exists: true
    drop_table :rentals, if_exists: true
    drop_table :reservations, if_exists: true




  end
end
