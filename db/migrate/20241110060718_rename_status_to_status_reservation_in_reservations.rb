class RenameStatusToStatusReservationInReservations < ActiveRecord::Migration[7.2]
  def change
    rename_column :reservations, :status, :status_reservation
  end
end
