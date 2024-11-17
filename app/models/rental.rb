class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :reservation
  belongs_to :rate

  has_one :invoice
  
  validates :actual_reservation_date,
            :expected_refund_date, 
            :actual_refund_date,
            :initial_odometer,
            :final_odometer,
            presence: true

  validates :user_id,
            :reservation_id,
            :rate_id,
            numericality: {only_integer: true, message: "It should be an integer"},
            presence: true
          
validates   :car_status_end, 
            inclusion: { in: car_status_ends.keys, message: "%{value} is invalid" },
            presence: true

validates   :car_status, 
            inclusion: { in: car_statuses.keys, message: "%{value} is invalid" },
            presence: true


  enum car_status: { good: 0, damaged: 1}
  enum car_status_end: { good: 0, damaged: 1}
end
