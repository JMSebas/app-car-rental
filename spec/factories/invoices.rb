FactoryBot.define do
  factory :invoice do
    reservation { nil }
    paymenttype { nil }
    tax { "9.99" }
  end
end
