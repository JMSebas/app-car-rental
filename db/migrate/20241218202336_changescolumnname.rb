class Changescolumnname < ActiveRecord::Migration[7.2]
  def change
    # In a new migration
rename_column :damages, :type, :damage_type
  end
end
