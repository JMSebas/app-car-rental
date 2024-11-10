class Invoice < ApplicationRecord
  belongs_to :rental
  belongs_to :payment_type
  
end
