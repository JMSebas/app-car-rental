class ReparationSerializer < Panko::Serializer
attributes :id, :entry_day, :exit_day,
has_one :vehicle, serializer: VehicleSerializer
end
