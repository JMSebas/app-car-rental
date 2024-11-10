class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :client
  belongs_to :vehicle
  belongs_to :rate

  

  validates :reservation_date, presence: true
  validates :refund_date, presence: true
  validate :refund_date_after_reservation_date
  validate :check_vehicle_availability

  
  private




  def refund_date_after_reservation_date
    return if reservation_date.blank? || refund_date.blank?

    if refund_date < reservation_date
      errors.add(:refund_date, "debe ser posterior a la fecha de reservación")
    end
  end

  def check_vehicle_availability
    return if vehicle.nil?

    active_reservation = Reservation.where(vehicle_id: vehicle_id)
                                 .where(status_reservation: 'in_reserved')
                                 .where.not(id: id) 
                                 .exists?

    if active_reservation
      errors.add(:base, "El vehículo tiene una reservación activa y no puede ser reservado")
    end
  end
end