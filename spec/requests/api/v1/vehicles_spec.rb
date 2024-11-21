require 'rails_helper'

RSpec.describe "Vehicles API", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end
  
  # Datos iniciales para las pruebas
  let!(:vehicles) { create_list(:vehicle, 5) } # Crear 5 vehículos
  let(:vehicle_id) { vehicles.first.id } # ID del primer vehículo

  # Pruebas para GET /api/v1/vehicles
  describe "GET /api/v1/vehicles" do
    before { get '/api/v1/vehicles' }

    it "retorna una lista de vehículos" do
      expect(response).to have_http_status(:ok) # HTTP 200
      expect(JSON.parse(response.body).size).to eq(5)
    end
  end

  # Pruebas para GET /api/v1/vehicles/:id
  describe "GET /api/v1/vehicles/:id" do
    before { get "/api/v1/vehicles/#{vehicle_id}" }

    context "cuando el vehículo existe" do
      it "retorna el vehículo" do
        expect(response).to have_http_status(:ok) # HTTP 200
        expect(JSON.parse(response.body)["id"]).to eq(vehicle_id)
      end
    end

    context "cuando el vehículo no existe" do
      let(:vehicle_id) { 9999 } # ID inexistente

      it "retorna un error 404" do
        expect(response).to have_http_status(:not_found) # HTTP 404
        expect(JSON.parse(response.body)["error"]).to eq("Vehicle not found")
      end
    end
  end

  # Pruebas para POST /api/v1/vehicles
  describe "POST /api/v1/vehicles" do
    let(:valid_attributes) { { brand: "Toyota", model: "Corolla", license_plate: "XYZ789", year: 2020, vehicle_type: "Sedan", status: "available", daily_rate: 50.0 } }

    context "con parámetros válidos" do
      it "crea un nuevo vehículo" do
        expect {
          post "/api/v1/vehicles", params: valid_attributes
        }.to change(Vehicle, :count).by(1)

        expect(response).to have_http_status(:created) # HTTP 201
      end
    end

    context "con parámetros inválidos" do
      let(:invalid_attributes) { { brand: nil, model: nil } }

      it "retorna un error" do
        post "/api/v1/vehicles", params: invalid_attributes

        expect(response).to have_http_status(:unprocessable_entity) # HTTP 422
        expect(JSON.parse(response.body)["errors"]).to include("Brand can't be blank", "Model can't be blank")
      end
    end
  end

  # Pruebas para PUT /api/v1/vehicles/:id
  describe "PUT /api/v1/vehicles/:id" do
    let(:valid_attributes) { { brand: "Updated Brand" } }

    context "cuando el vehículo existe" do
      before { put "/api/v1/vehicles/#{vehicle_id}", params: valid_attributes }

      it "actualiza el vehículo" do
        updated_vehicle = Vehicle.find(vehicle_id)
        expect(updated_vehicle.brand).to eq("Updated Brand")
        expect(response).to have_http_status(:ok) # HTTP 200
      end
    end

    context "cuando el vehículo no existe" do
      let(:vehicle_id) { 9999 } # ID inexistente

      it "retorna un error 404" do
        put "/api/v1/vehicles/#{vehicle_id}", params: valid_attributes

        expect(response).to have_http_status(:not_found) # HTTP 404
        expect(JSON.parse(response.body)["error"]).to eq("Vehicle not found")
      end
    end
  end

  # Pruebas para DELETE /api/v1/vehicles/:id
  describe "DELETE /api/v1/vehicles/:id" do
    context "cuando el vehículo existe" do
      it "elimina el vehículo" do
        expect {
          delete "/api/v1/vehicles/#{vehicle_id}"
        }.to change(Vehicle, :count).by(-1)

        expect(response).to have_http_status(:no_content) # HTTP 204
      end
    end

    context "cuando el vehículo no existe" do
      let(:vehicle_id) { 9999 } # ID inexistente

      it "retorna un error 404" do
        delete "/api/v1/vehicles/#{vehicle_id}"

        expect(response).to have_http_status(:not_found) # HTTP 404
        expect(JSON.parse(response.body)["error"]).to eq("Vehicle not found")
      end
    end
  end
end
