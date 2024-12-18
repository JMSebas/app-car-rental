class ChangeStringsXIntegers < ActiveRecord::Migration[7.2]
  def change
    change_column :rentals, :car_status, 'integer', using: 'car_status::integer'
    add_column :rentals, :car_status_end, :integer
    change_column :reservations, :status_reservation, :string, default: nil
    change_column :reservations, :status_reservation, :integer, using: 'status_reservation::integer'
    change_column_default :reservations, :status_reservation, 0
    change_column :vehicles, :status, 'integer', using: 'status::integer'
  end
end
