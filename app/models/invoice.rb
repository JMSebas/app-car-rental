class Invoice < ApplicationRecord
  belongs_to :rental
  belongs_to :payment_type
  
  before_create :calculate_tax

  validates :payment_day,
            :actual_payment_day,
            :payment_type_id, 
            :rental_id,
            presence: true

  private 
  def calculate_tax
    rate = rental.rate 
    start_date = rental.actual_reservation_date
    end_date = rental.actual_refund_date
    days_diff = (end_date - start_date).to_i

    self.tax = days_diff * rate.value_per_day
  end
end
