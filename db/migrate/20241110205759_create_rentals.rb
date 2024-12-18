class CreateRentals < ActiveRecord::Migration[7.2]
  def change
    create_table :rentals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reservation, null: false, foreign_key: true
      t.date :actual_reservation_date
      t.date :expected_refund_date
      t.date :actual_refund_date
      t.string :car_status
      t.decimal :initial_odometer
      t.decimal :final_odometer
      t.references :rate, null: false, foreign_key: true

      t.timestamps
    end
  end
end
