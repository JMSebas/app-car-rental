class ReservationSerializer < Panko::Serializer
attributes :id, :reservation_date, :refund_date, :status_reservation
has_one :vehicle, serializer: VehicleSerializer

end 

