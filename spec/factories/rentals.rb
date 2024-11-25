FactoryBot.define do
  factory :rental do
    user { nil }
    reservation { nil }
    actual_reservation_date { "2024-11-10" }
    expected_refund_date { "2024-11-10" }
    actual_refund_date { "2024-11-10" }
    car_status { nil }
    initial_odometer { "9.99" }
    final_odometer { "9.99" }
    rate { nil }
    car_status_end { nil}
  end
end
