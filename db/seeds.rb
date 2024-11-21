# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed data for vehicles

# Recommended gems:
# gem 'faker'

brands = [
  'Toyota', 'Honda', 'Ford', 'Chevrolet', 'Nissan', 'Mercedes-Benz', 
  'BMW', 'Audi', 'Volkswagen', 'Tesla'
]

vehicle_types = ['Sedan', 'SUV', 'Truck', 'Van', 'Electric', 'Hybrid']

Reservation.destroy_all
Rental.destroy_all
Vehicle.destroy_all  

10.times do
  Vehicle.create!(
    brand: brands.sample,
    model: Faker::Vehicle.model,
    license_plate: Faker::Vehicle.license_plate,
    year: rand(2010..2024),
    vehicle_type: vehicle_types.sample,
    status: 0,
    daily_rate: rand(30.0..250.0).round(2)
  )
end

User.destroy_all
users_data = [
  { name: 'Juan', lastname: 'Perez', address: 'Quito', phone: '0987654321', birthdate: '1995-03-15', username: 'jperez', email: 'juan@example.com', role: 0 },
  { name: 'Maria', lastname: 'Gomez', address: 'Guayaquil', phone: '0976543210', birthdate: '1998-07-25', username: 'mgomez', email: 'maria@example.com', role: 1 },
  { name: 'Carlos', lastname: 'Vera', address: 'Cuenca', phone: '0965432109', birthdate: '1987-11-10', username: 'cvera', email: 'carlos@example.com', role: 2 }
]

users_data.each do |user_data|
  User.create!(
    name: user_data[:name],
    lastname: user_data[:lastname],
    address: user_data[:address],
    phone: user_data[:phone],
    birthdate: user_data[:birthdate],
    username: user_data[:username],
    email: user_data[:email],
    password: 'password123',
    role: user_data[:role]
  )
end

# Test Data 


# payment_types = ['Credit Card', 'Cash', 'Bank Transfer']

# payment_types.each do |payment_method|
#   PaymentType.find_or_create_by!(payment_method: payment_method)
# end


# season1 = Season.find_or_create_by!(season: 'Summer', start_date: '2024-06-01', end_date: '2024-08-31')
# season2 = Season.find_or_create_by!(season: 'Winter', start_date: '2024-12-01', end_date: '2025-02-28')

# 10.times do
#   Rate.create!(
#     car_type: ['Sedan', 'SUV', 'Truck'].sample,
#     value_per_day: rand(30.0..100.0).round(2),
#     season_id: [season1.id, season2.id].sample
#   )
# end

# 10.times do
#   Reservation.create!(
#     user_id: User.all.sample.id, 
#     vehicle_id: Vehicle.all.sample.id, 
#     reservation_date: Date.today, 
#     refund_date: Date.today + rand(1..7).days,
#     status_reservation: rand(0..2)
#   )
# end

# 10.times do
#   Rental.create!(
#     user_id: User.all.sample.id,
#     reservation_id: Reservation.all.sample.id,
#     rate_id: Rate.all.sample.id,
#     actual_reservation_date: Date.today,
#     expected_refund_date: Date.today + rand(1..7).days,
#     actual_refund_date: Date.today + rand(1..7).days,
#     car_status: :good,
#     car_status_end: :damaged,
#     initial_odometer: rand(0..500),
#     final_odometer: rand(500..1000)
#   )
# end

# 10.times do
#   Invoice.create!(
#     rental_id: Rental.all.sample.id,
#     payment_type_id: PaymentType.all.sample.id,
#     tax: rand(5.0..50.0).round(2),
#     payment_day: Date.today,
#     actual_payment_day: Date.today
#   )
# end

# puts "Seed data TEST created successfully!"