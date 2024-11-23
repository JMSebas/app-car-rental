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
    
   
  end