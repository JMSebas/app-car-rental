class PaymentType < ApplicationRecord
    has_many :invoices

    validates :payment_method, presence: { message: "Payment method doesn't be empty"}
end
