class AddUrlImageToVehicles < ActiveRecord::Migration[7.2]
  def change
    add_column :vehicles, :image, :string
  end
end
