FactoryBot.define do
  factory :rate do
    car_type {['Sedan', 'SUV', 'Truck'].sample}
     value_per_day {rand(30.0..100.0).round(2)}
     season_id {[season1.id, season2.id].sample}
  end
end
