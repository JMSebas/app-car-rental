class Rental < ApplicationRecord
  before_create :add_dates

  belongs_to :user,  optional: true
  belongs_to :reservation
  belongs_to :rate

  has_one :invoice
  has_many :damages
  
  validates :initial_odometer,
            :final_odometer,
            presence: true

  validates :reservation_id,
            :rate_id,
            numericality: {only_integer: true, message: "It should be an integer"},
            presence: true


  enum car_status: { good: 0, semi: 1 }
  enum status: { in_process: 0, completed: 2}

  private 

  def add_dates 
    self.user_id = reservation.user_id
    self.actual_reservation_date = reservation.reservation_date
    self.expected_refund_date = reservation.refund_date

  end 
end
