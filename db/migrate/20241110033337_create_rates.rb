class CreateRates < ActiveRecord::Migration[7.2]
  def change
    create_table :rates do |t|
      t.string :carType
      t.decimal :ValuePerDay

      t.timestamps
    end
  end
end
