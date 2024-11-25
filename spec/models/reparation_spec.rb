# spec/models/reparation_spec.rb
require 'rails_helper'

RSpec.describe Reparation, type: :model do
  # Datos de prueba
  let(:vehicle) { create(:vehicle) }
  
  # Validaciones
  context 'validations' do
    it 'should validate presence of vehicle_id' do
      reparation = Reparation.new(vehicle_id: nil)
      expect(reparation).not_to be_valid
    end

    it 'should validate numericality of vehicle_id' do
      reparation = Reparation.new(vehicle_id: 'string_value')
      expect(reparation).not_to be_valid
    end

    it 'should validate presence of entry_day' do
      reparation = Reparation.new(entry_day: nil)
      expect(reparation).not_to be_valid
    end

    it 'should validate presence of exit_day' do
      reparation = Reparation.new(exit_day: nil)
      expect(reparation).not_to be_valid
    end
  end

  # Asociaciones
  context 'associations' do
    it 'should belong to vehicle' do
      should belong_to(:vehicle)
    end
  end

  # Creación de una reparación
  context 'creating a reparation' do
    it 'is valid with valid attributes' do
      reparation = Reparation.new(vehicle_id: vehicle.id, entry_day: Date.today, exit_day: Date.today + 1.day)
      expect(reparation).to be_valid
    end

    it 'is invalid without a vehicle_id' do
      reparation = Reparation.new(vehicle_id: nil, entry_day: Date.today, exit_day: Date.today + 1.day)
      expect(reparation).not_to be_valid
    end

    it 'is invalid without an entry_day' do
      reparation = Reparation.new(vehicle_id: vehicle.id, entry_day: nil, exit_day: Date.today + 1.day)
      expect(reparation).not_to be_valid
    end

    it 'is invalid without an exit_day' do
      reparation = Reparation.new(vehicle_id: vehicle.id, entry_day: Date.today, exit_day: nil)
      expect(reparation).not_to be_valid
    end

    it 'is invalid with a non-numeric vehicle_id' do
      reparation = Reparation.new(vehicle_id: 'non_numeric', entry_day: Date.today, exit_day: Date.today + 1.day)
      expect(reparation).not_to be_valid
    end
  end
end
