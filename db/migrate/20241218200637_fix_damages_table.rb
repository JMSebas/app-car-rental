class FixDamagesTable < ActiveRecord::Migration[7.2]
  def change
    # Cambiar 'value' de tipo string a decimal
    change_column :damages, :value, 'decimal USING value::numeric'

    # Eliminar columna 'decimal' que no es necesaria
    remove_column :damages, :decimal
    remove_column :damages, :string

    # Asegurarse de que 'type' sea un string
    change_column :damages, :type, :string
  end
end
