require 'rails_helper'

RSpec.describe Rate, type: :model do
  # Datos de prueba
  let(:season) { Season.create!(season: 'Summer', start_date: Date.today, end_date: Date.today + 3.months) }

  # Validaciones
  context 'validations' do
    it 'should validate presence of car_type' do
      rate = Rate.new(car_type: nil)
      expect(rate).not_to be_valid
    end

    it 'should validate presence of value_per_day' do
      rate = Rate.new(value_per_day: nil)
      expect(rate).not_to be_valid
    end

    it 'should validate presence of season_id' do
      rate = Rate.new(season_id: nil)
      expect(rate).not_to be_valid
    end
  end

  # Asociaciones
  context 'associations' do
    it 'should belong to a season' do
      rate = Rate.new(season_id: season.id)
      expect(rate).to belong_to(:season)
    end
  end

  # Creación de una tarifa
  context 'creating a rate' do
    it 'is valid with valid attributes' do
      rate = Rate.new(car_type: 'Sedan', value_per_day: 100.0, season_id: season.id)
      expect(rate).to be_valid
    end

    it 'is invalid without a car_type' do
      rate = Rate.new(car_type: nil, value_per_day: 100.0, season_id: season.id)
      expect(rate).not_to be_valid
    end

    it 'is invalid without a value_per_day' do
      rate = Rate.new(car_type: 'Sedan', value_per_day: nil, season_id: season.id)
      expect(rate).not_to be_valid
    end

    it 'is invalid without a season_id' do
      rate = Rate.new(car_type: 'Sedan', value_per_day: 100.0, season_id: nil)
      expect(rate).not_to be_valid
    end
  end
end
