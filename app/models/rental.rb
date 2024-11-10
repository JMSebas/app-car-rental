class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :reservation
  belongs_to :rate

  has_one :invoice
  
end
