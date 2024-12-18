class RentalSerializer < Panko::Serializer
attributes :id, :actual_refund_date, :actual_reservation_date, :car_status,
:initial_odometer, :final_odometer

has_many :damages, each_serializer: DamageSerializer
end
