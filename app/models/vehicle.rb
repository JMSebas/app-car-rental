class Vehicle < ApplicationRecord
    has_many :reservations
    has_many :reparations
    
    scope :available, -> { where(status: :available) }
    scope :unavailable, -> { where(status: :unavailable) }
    scope :reserved, -> { where(status: :reserved) }
    scope :damaged, -> { where(status: :damaged) }
  
    validates :brand, 
              :model,
              :license_plate,
              :vehicle_type,
              :year,
              :image, presence: true 

    
   
  
    enum status: { available: 0, unavailable: 1, reserved: 2, damaged: 3}
    
   # Validaciones
   validates :brand, presence: true
   validates :model, presence: true
   validates :license_plate, presence: true, uniqueness: true, length: { in: 5..10 }
   validates :vehicle_type, presence: true
   validates :status, presence: true
   validates :daily_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
   validates :year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: Time.now.year }
 end