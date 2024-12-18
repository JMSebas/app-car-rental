class AddFeaturesToCars < ActiveRecord::Migration[7.2]
  def change
    add_column :vehicles, :motor, :string
    add_column :vehicles,  :door_count, :integer
    add_column :vehicles, :chasis, :string
    add_column :vehicles, :storage, :integer

  end
end
