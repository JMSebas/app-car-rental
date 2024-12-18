class CreateDamages < ActiveRecord::Migration[7.2]
  def change
    create_table :damages do |t|
      t.string :type
      t.string :string
      t.string :value
      t.string :decimal
      t.references :rental, null: false, foreign_key: true

      t.timestamps
    end
  end
end
