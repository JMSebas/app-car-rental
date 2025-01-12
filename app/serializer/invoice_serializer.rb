class InvoiceSerializer < Panko::Serializer 
attributes :id, :tax, :payment_day, :actual_payment_day
has_one :user, serializer: UserSerializer
has_one :rental, serializer: RentalSerializer
has_one :payment, serializer: PaymentSerializer
end
