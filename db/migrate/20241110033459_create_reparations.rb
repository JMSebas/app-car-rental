class CreateReparations < ActiveRecord::Migration[7.2]
  def change
    create_table :reparations do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.date :entyDay
      t.date :exitDay

      t.timestamps
    end
  end
end
