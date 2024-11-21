class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :vehicle
  has_one :rental

  

  validates :reservation_date, presence: true
  validates :refund_date, presence: true

  validates :refund_date, comparison: { greater_than: :reservation_date, message: "Date is invalid bro" }
  validate :status_vehicle, on: :create

  enum status_reservation: { reserved: 0, cancelled: 1, completed: 2}
  
  private
  
  def status_vehicle 
    status = vehicle.status
    if status != "available"
      errors.add(:Error, "Vechiculo no disponible para reserva")
    end 
  end


  

end