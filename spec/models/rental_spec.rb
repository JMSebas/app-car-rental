# spec/models/rental_spec.rb
require 'rails_helper'

RSpec.describe Rental, type: :model do
  # Datos de prueba
  let(:season) { Season.create!(season: 'Summer', start_date: Date.today, end_date: Date.today + 3.months) }
  let(:user) { User.create!(email: 'user@example.com', password: 'password123', name: 'John', lastname: 'Doe', role: 0, address: 'Address', phone: '1234567890', birthdate: '1990-01-01', username: 'johndoe') }
  let(:vehicle) { Vehicle.create!(brand: 'Toyota', model: 'Corolla', license_plate: 'ABC123', year: 2020, vehicle_type: 'Sedan', status: 0, daily_rate: 60.0) }
  let(:reservation) { Reservation.create!(user_id: user.id, vehicle_id: vehicle.id, reservation_date: Date.today, refund_date: Date.today + 5.days) }
  let(:rate) { Rate.create!(car_type: 'Sedan', value_per_day: 50.0, season_id: season.id) }
  let(:payment_type) { PaymentType.create!(payment_method: 'Credit Card') }

  # Validaciones
  context 'validations' do
    it 'should validate presence of actual_reservation_date' do
      rental = Rental.new(actual_reservation_date: nil)
      expect(rental).not_to be_valid
    end

    it 'should validate presence of expected_refund_date' do
      rental = Rental.new(expected_refund_date: nil)
      expect(rental).not_to be_valid
    end

    it 'should validate presence of actual_refund_date' do
      rental = Rental.new(actual_refund_date: nil)
      expect(rental).not_to be_valid
    end

    it 'should validate presence of initial_odometer' do
      rental = Rental.new(initial_odometer: nil)
      expect(rental).not_to be_valid
    end

    it 'should validate presence of final_odometer' do
      rental = Rental.new(final_odometer: nil)
      expect(rental).not_to be_valid
    end

    it 'should validate presence of user_id' do
      rental = Rental.new(user_id: nil)
      expect(rental).not_to be_valid
    end

    it 'should validate presence of reservation_id' do
      rental = Rental.new(reservation_id: nil)
      expect(rental).not_to be_valid
    end

    it 'should validate presence of rate_id' do
      rental = Rental.new(rate_id: nil)
      expect(rental).not_to be_valid
    end
  end

  # Métodos personalizados
  context 'custom methods' do
    it 'calculates tax correctly based on rental dates and rate' do
      rental = Rental.create!(user_id: user.id, reservation_id: reservation.id, rate_id: rate.id, actual_reservation_date: Date.today, expected_refund_date: Date.today + 5.days, actual_refund_date: Date.today + 5.days, initial_odometer: 0, final_odometer: 100, car_status: :good)
      # Invoice should calculate the tax, not Rental
      invoice = rental.create_invoice!(payment_type_id: payment_type.id, payment_day: Date.today, actual_payment_day: Date.today)
      expect(invoice.tax).to eq((5 * rate.value_per_day))  # Asegúrate de que el cálculo de impuestos sea correcto
    end
  end

  # Enums de car_status y car_status_end
  context 'enums' do
    it 'should have a valid car_status' do
      rental = Rental.create!(user_id: user.id, reservation_id: reservation.id, rate_id: rate.id, car_status: :good, initial_odometer: 0, final_odometer: 100, actual_reservation_date: Date.today, expected_refund_date: Date.today + 5.days, actual_refund_date: Date.today + 5.days)
      expect(rental.car_status).to eq('good')
    end

    it 'should have a valid car_status_end' do
      rental = Rental.create!(user_id: user.id, reservation_id: reservation.id, rate_id: rate.id, car_status: :good, car_status_end: :damaged, initial_odometer: 0, final_odometer: 100, actual_reservation_date: Date.today, expected_refund_date: Date.today + 5.days, actual_refund_date: Date.today + 5.days)
      expect(rental.car_status_end).to eq('damaged')
    end
  end

  # Creación de un alquiler
  context 'creating a rental' do
    it 'is valid with valid attributes' do
      rental = Rental.new(user_id: user.id, reservation_id: reservation.id, rate_id: rate.id, actual_reservation_date: Date.today, expected_refund_date: Date.today + 5.days, actual_refund_date: Date.today + 5.days, initial_odometer: 0, final_odometer: 100, car_status: :good)
      expect(rental).to be_valid
    end

    it 'is invalid without a user_id' do
      rental = Rental.new(user_id: nil)
      expect(rental).not_to be_valid
    end

    it 'is invalid without a reservation_id' do
      rental = Rental.new(reservation_id: nil)
      expect(rental).not_to be_valid
    end

    it 'is invalid without a rate_id' do
      rental = Rental.new(rate_id: nil)
      expect(rental).not_to be_valid
    end
  end

  # Actualizaciones de atributos
  context 'attribute changes' do
    it 'updates the actual_refund_date correctly' do
      rental = Rental.create!(user_id: user.id, reservation_id: reservation.id, rate_id: rate.id, actual_reservation_date: Date.today, expected_refund_date: Date.today + 5.days, actual_refund_date: Date.today + 5.days, initial_odometer: 0, final_odometer: 100, car_status: :good)
      new_date = Date.today + 2.days
      rental.update(actual_refund_date: new_date)
      expect(rental.actual_refund_date).to eq(new_date)
    end
  end
end
