require 'rails_helper'

RSpec.describe Season, type: :model do
  # Datos de prueba
  let(:season) { Season.create!(season: 'Summer', start_date: Date.today, end_date: Date.today + 3.months) }

  # Validaciones
  context 'validations' do
    it 'should validate presence of season' do
      season = Season.new(season: nil)
      expect(season).not_to be_valid
    end

    it 'should validate presence of start_date' do
      season = Season.new(start_date: nil)
      expect(season).not_to be_valid
    end

    it 'should validate presence of end_date' do
      season = Season.new(end_date: nil)
      expect(season).not_to be_valid
    end

    it 'should validate that start_date is before end_date' do
      season = Season.new(start_date: Date.today, end_date: Date.yesterday)
      season.valid?
      expect(season.errors[:end_date]).to include("must be after the start date")
    end
  end

  # Asociaciones
  context 'associations' do
    it 'should have many rates' do
      should have_many(:rates)
    end
  end

  # Creación de una nueva temporada
  context 'creating a season' do
    it 'is valid with valid attributes' do
      season = Season.new(season: 'Winter', start_date: Date.today + 4.months, end_date: Date.today + 6.months)
      expect(season).to be_valid
    end

    it 'is invalid without a season name' do
      season = Season.new(season: nil, start_date: Date.today, end_date: Date.today + 3.months)
      expect(season).not_to be_valid
    end

    it 'is invalid without a start_date' do
      season = Season.new(season: 'Spring', start_date: nil, end_date: Date.today + 3.months)
      expect(season).not_to be_valid
    end

    it 'is invalid without an end_date' do
      season = Season.new(season: 'Autumn', start_date: Date.today, end_date: nil)
      expect(season).not_to be_valid
    end
  end
end
