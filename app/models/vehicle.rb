class Vehicle < ApplicationRecord
    has_many :reservations
    has_many :reparations
    
    # Scopes
    scope :available, -> { where(status: 'available') }
    scope :unavailable, -> { where(status: 'unavailable') }
    
    # Validaciones
    validates :status, presence: true, inclusion: { in: %w[available unavailable maintenance] }
    
    # Métodos de instancia
    def available?
      status == 'available'
    end
  
    def available_for_dates?(start_date, end_date)
      return false unless available?
      
      !reservations.where('(reservationDate <= ? AND refundDate >= ?) OR 
                          (reservationDate <= ? AND refundDate >= ?) OR
                          (reservationDate >= ? AND refundDate <= ?)',
                          start_date, start_date,
                          end_date, end_date,
                          start_date, end_date).exists?
    end
  
    def mark_as_unavailable!
      update!(status: 'unavailable')
    end
  
    def mark_as_available!
      update!(status: 'available')
    end
  end