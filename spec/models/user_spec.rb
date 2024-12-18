require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    describe 'presence validations' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:lastname) }
      it { should validate_presence_of(:address) }
      it { should validate_presence_of(:phone) }
      it { should validate_presence_of(:birthdate) }
      it { should validate_presence_of(:username) }
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:password) }
    end

    describe 'email validations' do
      it { should validate_uniqueness_of(:email).case_insensitive }
      
      it 'is not valid with invalid email format' do
        user.email = 'invalid_email'
        expect(user).not_to be_valid
      end
    end

    describe 'password validations' do
      it { should validate_length_of(:password).is_at_least(6) }
      
      it 'is not valid with a short password' do
        user.password = '12345'
        expect(user).not_to be_valid
      end
    end
  end

  describe '#jwt_payload' do
    it 'returns the jwt payload' do
      expect(user.jwt_payload).to be_a(Hash)
    end
  end

  describe 'devise modules' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end
end
