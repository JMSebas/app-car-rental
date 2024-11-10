class Vehicle < ApplicationRecord
    has_many :reservations
    has_many :reparations
    
    scope :available, -> { where(status: 'available') }
    scope :unavailable, -> { where(status: 'unavailable') }
  
  
    def available_for_dates?(start_date, end_date)
      return false unless available?
      
      !reservations.where('(reservationDate <= ? AND refundDate >= ?) OR 
                          (reservationDate <= ? AND refundDate >= ?) OR
                          (reservationDate >= ? AND refundDate <= ?)',
                          start_date, start_date,
                          end_date, end_date,
                          start_date, end_date).exists?
    end
  end