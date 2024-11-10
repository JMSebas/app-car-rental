class ChangeCamelCaseToSnakeCase < ActiveRecord::Migration[7.2]
  def change
    # Tabla: rates
    rename_column :rates, :carType, :car_type
    rename_column :rates, :ValuePerDay, :value_per_day

    # Tabla: reparations
    rename_column :reparations, :entyDay, :entry_day
    rename_column :reparations, :exitDay, :exit_day

    # Tabla: reservations
    rename_column :reservations, :reservationDate, :reservation_date
    rename_column :reservations, :refundDate, :refund_date
    rename_column :reservations, :carStatus, :car_status
  end
end
