class AddStatusToRentals < ActiveRecord::Migration[7.2]
  def change
    add_column :rentals, :status, :integer
  end
end
