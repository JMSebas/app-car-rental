require 'rails_helper'

RSpec.describe Reservation, type: :model do
  # Datos de prueba
  let(:user) { User.create!(
    email: 'user@example.com', 
    password: 'password123', 
    name: 'John', 
    lastname: 'Doe', 
    role: 0,
    address: '123 Main St', 
    phone: '0987654321', 
    birthdate: '1990-01-01', 
    username: 'johndoe'
  )}
  
  let(:vehicle) { Vehicle.create!( 
    brand: 'Toyota', 
    model: 'Corolla', 
    license_plate: 'ABC123', 
    year: 2020, 
    vehicle_type: 'Sedan', 
    status: 0, 
    daily_rate: 50.0
  )}
  
  # Validaciones
  context 'validations' do
    it 'should validate presence of reservation_date' do
      reservation = Reservation.new(reservation_date: nil, refund_date: Date.today + 2.days, user_id: user.id, vehicle_id: vehicle.id)
      expect(reservation).not_to be_valid
    end

    it 'should validate presence of refund_date' do
      reservation = Reservation.new(reservation_date: Date.today, refund_date: nil, user_id: user.id, vehicle_id: vehicle.id)
      expect(reservation).not_to be_valid
    end

    it 'should ensure refund_date is greater than reservation_date' do
      reservation = Reservation.new(reservation_date: Date.today, refund_date: Date.yesterday, user_id: user.id, vehicle_id: vehicle.id)
      reservation.valid?
      expect(reservation.errors[:refund_date]).to include("Date is invalid bro")
    end
  end

  # Asociación de modelos
  context 'associations' do
    it 'should belong to a user' do
      should belong_to(:user)
    end

    it 'should belong to a vehicle' do
      should belong_to(:vehicle)
    end

    it 'should have one rental' do
      should have_one(:rental)
    end
  end

  # Métodos personalizados
  context 'custom methods' do
    it 'should add an error if the vehicle is not available' do
      vehicle.update(status: 'reserved') # Cambiar el estado del vehículo
      reservation = Reservation.new(user_id: user.id, vehicle_id: vehicle.id, reservation_date: Date.today, refund_date: Date.tomorrow)
      reservation.valid?
      expect(reservation.errors[:Error]).to include("Vechiculo no disponible para reserva")
    end

    it 'should not add an error if the vehicle is available' do
      vehicle.update(status: 'available') # Cambiar el estado del vehículo a disponible
      reservation = Reservation.new(user_id: user.id, vehicle_id: vehicle.id, reservation_date: Date.today, refund_date: Date.tomorrow)
      reservation.valid?
      expect(reservation.errors[:Error]).to be_empty
    end
  end

  # Creación de una nueva reserva
  context 'creating a reservation' do
    it 'is valid with valid attributes' do
      reservation = Reservation.new(user_id: user.id, vehicle_id: vehicle.id, reservation_date: Date.today, refund_date: Date.today + 2.days)
      expect(reservation).to be_valid
    end

    it 'is invalid without a user_id' do
      reservation = Reservation.new(user_id: nil, vehicle_id: vehicle.id, reservation_date: Date.today, refund_date: Date.today + 2.days)
      expect(reservation).not_to be_valid
    end

    it 'is invalid without a vehicle_id' do
      reservation = Reservation.new(user_id: user.id, vehicle_id: nil, reservation_date: Date.today, refund_date: Date.today + 2.days)
      expect(reservation).not_to be_valid
    end
  end
end
