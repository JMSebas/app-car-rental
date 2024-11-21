require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  # Datos de prueba
  let(:vehicle) { build(:vehicle) }

  # Validaciones
  context 'validations' do
    it 'is valid with valid attributes' do
      expect(vehicle).to be_valid
    end

    it 'is not valid without required attributes' do
      %i[status brand model license_plate vehicle_type daily_rate].each do |attr|
        vehicle.send("#{attr}=", nil)
        expect(vehicle).not_to be_valid, "#{attr} should be present"
      end
    end

    it 'is not valid with a negative daily_rate' do
      vehicle.daily_rate = -10
      expect(vehicle).not_to be_valid
    end

    it 'does not allow duplicate license_plate' do
      create(:vehicle, license_plate: vehicle.license_plate)
      expect(vehicle).not_to be_valid
    end

    it 'is not valid if license_plate is too short' do
      vehicle.license_plate = 'AB1'
      expect(vehicle).not_to be_valid
    end

    it 'is not valid if license_plate is too long' do
      vehicle.license_plate = 'ABCDEFGHI12345'
      expect(vehicle).not_to be_valid
    end

    it 'is not valid with a non-numeric year' do
      vehicle.year = 'two thousand'
      expect(vehicle).not_to be_valid
    end

    it 'is not valid if year is less than 1900' do
      vehicle.year = 1800
      expect(vehicle).not_to be_valid
    end

    it 'is valid with a year between 1900 and the current year' do
      vehicle.year = Time.now.year
      expect(vehicle).to be_valid
    end
  end

  # Scopes
  context 'scopes' do
    before do
      @available_vehicle = create(:vehicle, status: :available, license_plate: "ABC123")
      @unavailable_vehicle = create(:vehicle, status: :unavailable, license_plate: "XYZ789")
    end
  
    it 'includes only available vehicles in the available scope' do
      expect(Vehicle.available).to include(@available_vehicle)
      expect(Vehicle.available).not_to include(@unavailable_vehicle)
    end
  
    it 'includes only unavailable vehicles in the unavailable scope' do
      expect(Vehicle.unavailable).to include(@unavailable_vehicle)
      expect(Vehicle.unavailable).not_to include(@available_vehicle)
    end
  end  

  # Asociaciones
  context 'associations' do
    it { should have_many(:reservations) }
    it { should have_many(:reparations) }
  end

  # Métodos personalizados
  context 'custom methods' do
    describe '#available?' do
      it 'returns true if the vehicle status is available' do
        vehicle.status = 'available'
        expect(vehicle.available?).to be true
      end

      it 'returns false if the vehicle status is not available' do
        vehicle.status = 'unavailable'
        expect(vehicle.available?).to be false
      end
    end
  end
end
