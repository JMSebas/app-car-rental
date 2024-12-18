class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.string :dni
      t.string :name
      t.string :last_name

      t.timestamps
    end
  end
end
