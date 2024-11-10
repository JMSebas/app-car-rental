class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :client
  belongs_to :vehicle
  belongs_to :rate

  # Validaciones
  validates :reservation_date, presence: true
  validates :refund_date, presence: true
  validate :refund_date_after_reservation_date
  validate :vehicle_available_for_dates
  
  # Callbacks
  after_create :update_vehicle_status
  after_destroy :restore_vehicle_status

  private

  def refund_date_after_reservation_date
    return if reservation_date.blank? || refund_date.blank?

    if refund_date < reservation_date
      errors.add(:refund_date, "debe ser posterior a la fecha de reservación")
    end
  end

  def vehicle_available_for_dates
    return if vehicle.nil? || reservation_date.blank? || refund_date.blank?

    overlapping_reservations = Reservation.where(vehicle_id: vehicle_id)
                                          .where.not(id: id) # Excluir la reservación actual en caso de updates
                                          .where('(reservation_date <= ? AND refund_date >= ?) OR 
                                                 (reservation_date <= ? AND refund_date >= ?) OR
                                                 (reservation_date >= ? AND refund_date <= ?)',
                                                 reservation_date, reservation_date,
                                                 refund_date, refund_date,
                                                 reservation_date, refund_date)

    if overlapping_reservations.exists?
      errors.add(:base, "El vehículo no está disponible para las fechas seleccionadas")
    end
  end

  def update_vehicle_status
    vehicle.update!(status: 'unavailable')
  end

  def restore_vehicle_status
    # Solo restaurar el estado si no hay más reservaciones activas
    unless vehicle.reservations.where('refund_date > ?', Date.today).exists?
      vehicle.update!(status: 'available')
    end
  end
end
