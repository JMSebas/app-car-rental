FactoryBot.define do
  factory :reservation do
    user { nil }
    client { nil }
    vehicle { nil }
    reservationDate { "2024-11-09" }
    refundDate { "2024-11-09" }
    carStatus { "MyString" }
    rate { nil }
  end
end
