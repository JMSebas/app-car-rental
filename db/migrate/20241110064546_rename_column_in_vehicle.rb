class RenameColumnInVehicle < ActiveRecord::Migration[7.2]
  def change
    rename_column :vehicles, :type, :vehicle_type
  end
end
