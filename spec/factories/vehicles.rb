FactoryBot.define do
    factory :vehicle do
      brand { "Toyota" }
      model { "Corolla" }
      sequence(:license_plate) { |n| "ABC#{n}123" }
      year { 2020 }
      vehicle_type { "Sedan" }
      status { 0 }
      daily_rate { 50.0 }
    end
  end
  