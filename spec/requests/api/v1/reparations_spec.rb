require 'rails_helper'

RSpec.describe "Reparations Integration API", type: :request do
  # Crear un vehículo de prueba
  let(:vehicle) { create(:vehicle) }
  let!(:reparations) { create_list(:reparation, 3, vehicle: vehicle) }
  let(:reparation_id) { reparations.first.id }

  # Autenticación
  let(:admin_user) { create(:admin_user) }

  before do
    post '/users/sign_in', params: { user: { email: admin_user.email, password: admin_user.password } }
    token = JSON.parse(response.body).dig('status', 'access_token')
    @auth_headers = { Authorization: "Bearer #{token}" }
  end

  # Pruebas para el endpoint GET /api/v1/reparations
  describe "GET /api/v1/reparations" do
    it "retorna una lista de reparaciones" do
      get '/api/v1/reparations', headers: @auth_headers
      expect(response).to have_http_status(:ok) # HTTP 200
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  # Pruebas para el endpoint GET /api/v1/reparations/:id
  describe "GET /api/v1/reparations/:id" do
    context "cuando la reparación existe" do
      it "retorna la reparación" do
        get "/api/v1/reparations/#{reparation_id}", headers: @auth_headers
        expect(response).to have_http_status(:ok) # HTTP 200
        expect(JSON.parse(response.body)["id"]).to eq(reparation_id)
      end
    end

    context "cuando la reparación no existe" do
      it "retorna un error 404" do
        get "/api/v1/reparations/9999", headers: @auth_headers
        expect(response).to have_http_status(:not_found) # HTTP 404
        expect(JSON.parse(response.body)["error"]).to eq("Couldn't find Reparation with 'id'=9999")
      end
    end
  end

  # Pruebas para el endpoint POST /api/v1/reparations
  describe "POST /api/v1/reparations" do
    let(:valid_attributes) do
      {
        reparation: {
          vehicle_id: vehicle.id,
          entry_day: Date.today,
          exit_day: Date.today + 1.day
        }
      }
    end

    context "con parámetros válidos" do
      it "crea una nueva reparación" do
        expect {
          post "/api/v1/reparations", params: valid_attributes, headers: @auth_headers
        }.to change(Reparation, :count).by(1)

        expect(response).to have_http_status(:created) # HTTP 201
      end
    end

    context "con parámetros inválidos" do
      let(:invalid_attributes) { { reparation: { vehicle_id: vehicle.id, entry_day: 123, exit_day: Date.today } } }

      it "retorna un error 422" do
        post "/api/v1/reparations", params: invalid_attributes, headers: @auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # Pruebas para el endpoint PUT /api/v1/reparations/:id
  describe "PUT /api/v1/reparations/:id" do
    let(:valid_attributes) { { reparation: { exit_day: Date.today + 5.days } } }

    context "cuando la reparación existe" do
      it "actualiza la reparación" do
        put "/api/v1/reparations/#{reparation_id}", params: valid_attributes, headers: @auth_headers
        expect(response).to have_http_status(:ok) # HTTP 200
        updated_reparation = Reparation.find(reparation_id)
        expect(updated_reparation.exit_day).to eq(Date.today + 5.days)
      end
    end

    context "cuando la reparación no existe" do
      it "retorna un error 404" do
        put "/api/v1/reparations/9999", params: valid_attributes, headers: @auth_headers
        expect(response).to have_http_status(:not_found) # HTTP 404
      end
    end
  end

  # Pruebas para el endpoint DELETE /api/v1/reparations/:id
  describe "DELETE /api/v1/reparations/:id" do
    context "cuando la reparación existe" do
      it "elimina la reparación" do
        expect {
          delete "/api/v1/reparations/#{reparation_id}", headers: @auth_headers
        }.to change(Reparation, :count).by(-1)

        expect(response).to have_http_status(:ok) # HTTP 200
      end
    end

    context "cuando la reparación no existe" do
      it "retorna un error 404" do
        delete "/api/v1/reparations/9999", headers: @auth_headers
        expect(response).to have_http_status(:not_found) # HTTP 404
      end
    end
  end
end
