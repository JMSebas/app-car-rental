class VehicleSerializer < Panko::Serializer
    attributes :id, 
            :brand, 
            :model,
            :year,
            :license_plate,
            :vehicle_type,
            :daily_rate,
            :door_count,
            :storage
  end