class Invoice < ApplicationRecord
  belongs_to :reservation
  belongs_to :payment_type
end
