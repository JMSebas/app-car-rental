# spec/models/payment_type_spec.rb
require 'rails_helper'

RSpec.describe PaymentType, type: :model do
  # Datos de prueba
  let(:payment_type) { PaymentType.create!(payment_method: 'Credit Card') }

  # Validaciones
  context 'validations' do
    it 'should validate presence of payment_method' do
      payment_type = PaymentType.new(payment_method: nil)
      expect(payment_type).not_to be_valid
    end

    it 'should give a custom error message when payment_method is nil' do
      payment_type = PaymentType.new(payment_method: nil)
      payment_type.valid?
      expect(payment_type.errors[:payment_method]).to include("Payment method doesn't be empty")
    end
  end

  # Asociaciones
  context 'associations' do
    it 'should have many invoices' do
      expect(payment_type).to have_many(:invoices)
    end
  end

  # Creación de un nuevo PaymentType
  context 'creating a new payment type' do
    it 'is valid with valid attributes' do
      payment_type = PaymentType.new(payment_method: 'Cash')
      expect(payment_type).to be_valid
    end

    it 'is invalid without a payment_method' do
      payment_type = PaymentType.new(payment_method: nil)
      expect(payment_type).not_to be_valid
    end
  end
end
