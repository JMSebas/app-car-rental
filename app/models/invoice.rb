class Invoice < ApplicationRecord
  belongs_to :rental
  belongs_to :payment_type
  
  before_create :calculate_tax
  before_create :calculate_amout_damaged
  after_create :calculate_total_amout

  validates :payment_day,
            :actual_payment_day,
            :payment_type_id, 
            presence: true

  private 
  def calculate_tax
    rate = rental.rate
    value_per_day = rental.reservation.vehicle.daily_rate 

    start_date = rental.actual_reservation_date
    end_date = rental.expected_refund_date
    true_date = rental.actual_refund_date
    days_diff = (end_date - start_date + (true_date - end_date ) ).to_i
    self.tax = days_diff * value_per_day + rate.value_per_day
  end

  def calculate_amout_damaged
    self.amountxDamaged = rental.damages.sum(:value)
  end

  def calculate_total_amout
    self.totalAmount = amountxDamaged + tax
  end

end


