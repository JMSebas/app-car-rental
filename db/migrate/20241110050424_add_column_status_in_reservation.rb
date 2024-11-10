class AddColumnStatusInReservation < ActiveRecord::Migration[7.2]
  def change
    add_column :reservations, :status, :string
  end
end
