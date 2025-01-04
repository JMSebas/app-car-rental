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

# Reservation.destroy_all
# Rental.destroy_all
Vehicle.destroy_all  

10.times do
  Vehicle.create!(
    brand: brands.sample,
    model: Faker::Vehicle.model,
    license_plate: Faker::Vehicle.license_plate,
    year: rand(2010..2024),
    vehicle_type: vehicle_types.sample,
    status: 0,
    daily_rate: rand(30.0..250.0).round(2),
    image: "https://img.freepik.com/fotos-premium/representacion-3d-automovil-generico-marca-entorno-estudio-blanco_101266-12914.jpg"
  )
end

# User.destroy_all
# users_data = [
#   { name: 'Juan', lastname: 'Perez', address: 'Quito', phone: '0987654321', birthdate: '1995-03-15', username: 'jperez', email: 'juan@example.com', role: 0 },
#   { name: 'Maria', lastname: 'Gomez', address: 'Guayaquil', phone: '0976543210', birthdate: '1998-07-25', username: 'mgomez', email: 'maria@example.com', role: 1 },
#   { name: 'Carlos', lastname: 'Vera', address: 'Cuenca', phone: '0965432109', birthdate: '1987-11-10', username: 'cvera', email: 'carlos@example.com', role: 2 }
# ]

# users_data.each do |user_data|
#   User.create!(
#     name: user_data[:name],
#     lastname: user_data[:lastname],
#     address: user_data[:address],
#     phone: user_data[:phone],
#     birthdate: user_data[:birthdate],
#     username: user_data[:username],
#     email: user_data[:email],
#     password: 'password123',
#     role: user_data[:role]
#   )
# end
