FactoryBot.define do
  # factory :invoice do
  #   reservation { nil }
  #   paymenttype { nil }
  #   tax { "9.99" }
  # end

  factory :invoice do
    association :payment_type
    association :rental
    tax { 10.5 }
    payment_day { Date.today }
    actual_payment_day { Date.today }
  end
end
