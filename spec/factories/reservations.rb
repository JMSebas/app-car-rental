FactoryBot.define do
  factory :reservation do
    user { nil }
    vehicle { nil }
    reservation_date {Date.today}
    refund_date{ Date.today + rand(1..7).days}
    status_reservation { nil }
  end
end
