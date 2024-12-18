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
              :chasis,
              :motor,
              :storage,
              :door_count,
              :image, presence: true 
    #validates :year, :door_count numericality    
   
    validate :url_image_is_valid_url
  
    enum status: { available: 0, unavailable: 1, reserved: 2, damaged: 3}
    enum storage: {no_storage: 0, small: 1, large: 2}

    private 

    def url_image_is_valid_url
      uri = URI.parse(image)
      unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      errors.add(:image, "La URL no es valida no posee HTTP ni HTTPS") 
      end

    rescue URI::InvalidURIError
      errors.add(:image, "No es una URL válida")
    end
   
  end