class PaymentType < ApplicationRecord
    has_many :invoices
end
