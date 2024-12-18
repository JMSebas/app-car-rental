class DeleteSomeColumns < ActiveRecord::Migration[7.2]
  def change
    remove_column :rentals, :car_status_end
  end
end
