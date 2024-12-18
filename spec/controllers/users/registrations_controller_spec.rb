
require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_user) do
        {
          name: "Adrian",
          lastname: "Jurado",
          address: "123 secot",
          phone: "099832123",
          birthdate: "1990-05-15",
          username: "ajurado",
          email: "adrian1@example.com",
          password: "adrian123"
        }
      end

      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_user }
        }.to change(User, :count).by(1)
      end

      it 'returns a success response' do
        post :create, params: { user: valid_user }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']['code']).to eq(200)
        expect(json_response['status']['message']).to eq('Signed up successfully')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_user) do
        {
          name: "Adrian",
          lastname: "Jurado",
          address: "123 secot",
          phone: "099832123",
          birthdate: "1990-05-15",
          username: "ajurado",
          email: "invalid_email", 
          password: ""             
        }
      end

      it 'does not create a user' do
        expect {
          post :create, params: { user: invalid_user }
        }.not_to change(User, :count)
      end

      it 'returns an unprocessable entity response' do
        post :create, params: { user: invalid_user }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['status']['message']).to eq('User could not be created successfully')
      end
    end
  end
end
