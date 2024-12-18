class CreateReservations < ActiveRecord::Migration[7.2]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.date :reservationDate
      t.date :refundDate
      t.string :carStatus
      t.references :rate, null: false, foreign_key: true

      t.timestamps
    end
  end
end
