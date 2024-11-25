require 'rails_helper'

RSpec.describe 'Admin Vehicles Management API', type: :request do
  # Crear un usuario administrador
  let(:admin_user) { create(:admin_user) }

  # Autenticación previa al inicio de las pruebas
  before do
    post '/users/sign_in', params: { user: { email: admin_user.email, password: admin_user.password } }
    token = JSON.parse(response.body).dig('status', 'access_token')
    @auth_headers = { Authorization: "Bearer #{token}" }
  end

  # Datos iniciales para pruebas
  let!(:vehicles) { create_list(:vehicle, 5) } # Crear 5 vehículos
  let(:vehicle_id) { vehicles.first.id } # ID del primer vehículo

  # Pruebas para GET /api/v1/vehicles
  describe 'GET /api/v1/vehicles' do
    before { get '/api/v1/vehicles', headers: @auth_headers }

    it 'retorna una lista de vehículos' do
      expect(response).to have_http_status(:ok) # HTTP 200
      expect(JSON.parse(response.body).size).to eq(5)
    end
  end

  # Pruebas para GET /api/v1/vehicles/:id
  describe 'GET /api/v1/vehicles/:id' do
    context 'cuando el vehículo existe' do
      before { get "/api/v1/vehicles/#{vehicle_id}", headers: @auth_headers }

      it 'retorna el vehículo' do
        expect(response).to have_http_status(:ok) # HTTP 200
        expect(JSON.parse(response.body)['id']).to eq(vehicle_id)
      end
    end

    context 'cuando el vehículo no existe' do
      before { get '/api/v1/vehicles/9999', headers: @auth_headers } # ID inexistente

      it 'retorna un error 404' do
        expect(response).to have_http_status(:not_found) # HTTP 404
        expect(JSON.parse(response.body)['error']).to eq('Vehículo no encontrado')
      end
    end
  end

  # Pruebas para POST /api/v1/vehicles
  describe 'POST /api/v1/vehicles' do
    let(:valid_attributes) do
      {
        vehicle: {
          brand: 'Nissan',
          model: 'Sentra',
          license_plate: 'XYZ789',
          year: 2021,
          vehicle_type: 'Sedan',
          status: 'available',
          daily_rate: 60.0,
          image: 'https://example.com/image.jpg'
        }
      }
    end

    context 'con parámetros válidos' do
      it 'crea un nuevo vehículo' do
        expect {
          post '/api/v1/vehicles', params: valid_attributes, headers: @auth_headers
        }.to change(Vehicle, :count).by(1)

        expect(response).to have_http_status(:created) # HTTP 201
      end
    end

    context 'con parámetros inválidos' do
      let(:invalid_attributes) { { vehicle: { brand: nil, model: nil, image: nil } } }

      it 'retorna un error 422' do
        post '/api/v1/vehicles', params: invalid_attributes, headers: @auth_headers

        expect(response).to have_http_status(:unprocessable_entity) # HTTP 422
        expect(JSON.parse(response.body)['errors']).to include("Brand can't be blank", "Model can't be blank", "Image can't be blank")
      end
    end
  end

  # Pruebas para PUT /api/v1/vehicles/:id
  describe 'PUT /api/v1/vehicles/:id' do
    let(:valid_attributes) { { vehicle: { brand: 'Updated Brand', image: 'https://example.com/updated_image.jpg' } } }

    context 'cuando el vehículo existe' do
      before { put "/api/v1/vehicles/#{vehicle_id}", params: valid_attributes, headers: @auth_headers }

      it 'actualiza el vehículo' do
        updated_vehicle = Vehicle.find(vehicle_id)
        expect(updated_vehicle.brand).to eq('Updated Brand')
        expect(updated_vehicle.image).to eq('https://example.com/updated_image.jpg')
        expect(response).to have_http_status(:ok) # HTTP 200
      end
    end

    context 'cuando el vehículo no existe' do
      before { put '/api/v1/vehicles/9999', params: valid_attributes, headers: @auth_headers }

      it 'retorna un error 404' do
        expect(response).to have_http_status(:not_found) # HTTP 404
        expect(JSON.parse(response.body)['error']).to eq('Vehículo no encontrado')
      end
    end
  end

  # Pruebas para DELETE /api/v1/vehicles/:id
  describe 'DELETE /api/v1/vehicles/:id' do
    context 'cuando el vehículo existe' do
      it 'elimina el vehículo' do
        expect {
          delete "/api/v1/vehicles/#{vehicle_id}", headers: @auth_headers
        }.to change(Vehicle, :count).by(-1)

        expect(response).to have_http_status(:ok) # HTTP 204
      end
    end

    context 'cuando el vehículo no existe' do
      before { delete '/api/v1/vehicles/9999', headers: @auth_headers }

      it 'retorna un error 404' do
        expect(response).to have_http_status(:not_found) # HTTP 404
        expect(JSON.parse(response.body)['error']).to eq('Vehículo no encontrado')
      end
    end
  end
end
