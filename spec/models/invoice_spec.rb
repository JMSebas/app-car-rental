require 'rails_helper'

RSpec.describe Invoice, type: :model do
  # Crear un Season válido
  let(:season) { Season.create!(season: 'Summer', start_date: Date.today, end_date: Date.today + 30.days) }

  # Crear un User válido
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

  # Crear un Vehicle válido
  let(:vehicle) { Vehicle.create!( 
    brand: 'Toyota', 
    model: 'Corolla', 
    license_plate: 'ABC123', 
    year: 2020, 
    vehicle_type: 'Sedan', 
    status: 0, 
    daily_rate: 50.0
  )}

  # Crear una Reservation válida
  let(:reservation) { Reservation.create!(user_id: user.id, vehicle_id: vehicle.id, reservation_date: Date.today, refund_date: Date.today + 5.days) }

  # Crear un Rate válido (requiere Season)
  let(:rate) { Rate.create!(car_type: 'Sedan', value_per_day: 50.0, season_id: season.id) }

  # Crear un PaymentType válido
  let(:payment_type) { PaymentType.create!(payment_method: 'Credit Card') }

  # Crear un Rental válido
  let(:rental) { Rental.create!(
    user_id: user.id,
    reservation_id: reservation.id,
    rate_id: rate.id,
    actual_reservation_date: Date.today,
    expected_refund_date: Date.today + 5.days,
    actual_refund_date: Date.today + 5.days,
    initial_odometer: 0,
    final_odometer: 100,
    car_status: :good,
    car_status_end: :damaged
  )}

  # 1. Validaciones

  context 'validations' do
    it { should validate_presence_of(:payment_type_id) }
    it { should validate_presence_of(:rental_id) }
    it { should validate_presence_of(:payment_day) }
    it { should validate_presence_of(:actual_payment_day) }

    it 'should calculate tax correctly based on the rental dates' do
      expected_tax = (rental.actual_refund_date - rental.actual_reservation_date).to_i * rental.rate.value_per_day
      invoice = Invoice.create!(payment_type_id: payment_type.id, rental_id: rental.id, payment_day: Date.today, actual_payment_day: Date.today)
      expect(invoice.tax).to eq(expected_tax)
    end
  end

  # 2. Asociaciones

  context 'associations' do
    it { should belong_to(:payment_type) }
    it { should belong_to(:rental) }
  end

  # 3. Métodos personalizados

  context 'custom methods' do
    it 'calculates the total amount with tax' do
      invoice = Invoice.create!(payment_type_id: payment_type.id, rental_id: rental.id, tax: 15.0, payment_day: Date.today, actual_payment_day: Date.today)
      expect(invoice.tax).to eq((rental.actual_refund_date - rental.actual_reservation_date).to_i * rental.rate.value_per_day)
    end
  end

  # 4. Creación de una nueva factura

  context 'creating a new invoice' do
    it 'is valid with valid attributes' do
      invoice = Invoice.new(payment_type_id: payment_type.id, rental_id: rental.id, tax: 10.5, payment_day: Date.today, actual_payment_day: Date.today)
      expect(invoice).to be_valid
    end

    it 'is invalid without a payment_type_id' do
      invoice = Invoice.new(rental_id: rental.id, tax: 10.5, payment_day: Date.today, actual_payment_day: Date.today)
      expect(invoice).not_to be_valid
    end

    it 'is invalid without a rental_id' do
      invoice = Invoice.new(payment_type_id: payment_type.id, tax: 10.5, payment_day: Date.today, actual_payment_day: Date.today)
      expect(invoice).not_to be_valid
    end
  end

  # 5. Comportamiento de objetos y actualizaciones

  context 'attribute changes' do
    it 'updates the actual_payment_day correctly' do
      invoice = Invoice.create!(payment_type_id: payment_type.id, rental_id: rental.id, tax: 10.5, payment_day: Date.today, actual_payment_day: Date.today)
      new_date = Date.today + 2.days
      invoice.update(actual_payment_day: new_date)
      expect(invoice.actual_payment_day).to eq(new_date)
    end
  end

  # 6. Relaciones entre las tablas

  context 'associated records' do
    it 'can belong to a rental' do
      invoice = Invoice.create!(payment_type_id: payment_type.id, rental_id: rental.id, tax: 10.5, payment_day: Date.today, actual_payment_day: Date.today)
      expect(invoice.rental).to eq(rental)
    end

    it 'can belong to a payment type' do
      invoice = Invoice.create!(payment_type_id: payment_type.id, rental_id: rental.id, tax: 10.5, payment_day: Date.today, actual_payment_day: Date.today)
      expect(invoice.payment_type).to eq(payment_type)
    end
  end
end
