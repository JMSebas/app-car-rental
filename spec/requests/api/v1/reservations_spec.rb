require 'rails_helper'

RSpec.describe "Reservations Integration API", type: :request do
  # Crear un usuario administrador
  let(:admin_user) { create(:admin_user) }

  # Autenticación previa al inicio de las pruebas
  before do
    post '/users/sign_in', params: { user: { email: admin_user.email, password: admin_user.password } }
    token = JSON.parse(response.body).dig('status', 'access_token')
    @auth_headers = { Authorization: "Bearer #{token}" }
  end

  # Datos iniciales
  let(:user) { create(:user) }
  let(:vehicle) { create(:vehicle, status: 0) }
  let!(:reservations) { create_list(:reservation, 3, user: user, vehicle: vehicle) }
  let(:reservation_id) { reservations.first.id }

  # Pruebas para el endpoint GET /api/v1/reservations
  describe "GET /api/v1/reservations" do
    it "retorna una lista de reservas" do
      get '/api/v1/reservations', headers: @auth_headers
      expect(response).to have_http_status(:ok) # HTTP 200
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  # Pruebas para el endpoint GET /api/v1/reservations/:id
  describe "GET /api/v1/reservations/:id" do
    context "cuando la reserva existe" do
      it "retorna la reserva" do
        get "/api/v1/reservations/#{reservation_id}", headers: @auth_headers
        expect(response).to have_http_status(:ok) # HTTP 200
        expect(JSON.parse(response.body)["id"]).to eq(reservation_id)
      end
    end

    context "cuando la reserva no existe" do
      it "retorna un error 404" do
        get "/api/v1/reservations/9999", headers: @auth_headers
        expect(response).to have_http_status(:not_found) # HTTP 404
        expect(JSON.parse(response.body)["error"]).to eq("Couldn't find Reservation with 'id'=9999")
      end
    end
  end

  # Pruebas para el endpoint POST /api/v1/reservations
  describe "POST /api/v1/reservations" do
    let(:valid_attributes) do
      {
        reservation: {
          user_id: user.id,
          vehicle_id: vehicle.id,
          reservation_date: Date.today,
          refund_date: Date.today + 3.days,
          status_reservation: "reserved"
        }
      }
    end

    context "con parámetros válidos" do
      it "crea una nueva reserva" do
        expect {
          post "/api/v1/reservations", params: valid_attributes, headers: @auth_headers
        }.to change(Reservation, :count).by(1)

        expect(response).to have_http_status(:created) # HTTP 201
      end
    end

    context "con parámetros inválidos" do
      let(:invalid_attributes) { { reservation: { user_id: nil, vehicle_id: nil } } }

      it "retorna un error 422" do
        post "/api/v1/reservations", params: invalid_attributes, headers: @auth_headers
        expect(response).to have_http_status(:unprocessable_entity) # HTTP 422
      end
    end
  end

  # Pruebas para el endpoint PATCH /api/v1/reservations/:id
  describe "PUT /api/v1/reservations/:id" do
    before do
      reservations.first.update!(status_reservation: :reserved)
    end
  
    let(:valid_attributes) do
      {
        reservation: {
          refund_date: Date.today + 5.days # Solo actualiza refund_date
        }
      }
    end
  
    context "cuando la reserva existe" do
      it "actualiza la reserva" do
        put "/api/v1/reservations/#{reservation_id}", params: valid_attributes, headers: @auth_headers
  
        puts response.body if response.status == 422 # Ayuda a depurar si falla
  
        expect(response).to have_http_status(:ok) # HTTP 200
        updated_reservation = Reservation.find(reservation_id)
        expect(updated_reservation.refund_date).to eq(Date.today + 5.days)
      end
    end
  
    context "cuando la reserva no existe" do
      it "retorna un error 404" do
        put "/api/v1/reservations/9999", params: valid_attributes, headers: @auth_headers
        expect(response).to have_http_status(:not_found) # HTTP 404
      end
    end
  end
  

  # Pruebas para el endpoint DELETE /api/v1/reservations/:id
  describe "DELETE /api/v1/reservations/:id" do
    context "cuando la reserva existe" do
      it "elimina la reserva" do
        expect {
          delete "/api/v1/reservations/#{reservation_id}", headers: @auth_headers
        }.to change(Reservation, :count).by(-1)

        expect(response).to have_http_status(:ok) # HTTP 200
      end
    end

    context "cuando la reserva no existe" do
      it "retorna un error 404" do
        delete "/api/v1/reservations/9999", headers: @auth_headers
        expect(response).to have_http_status(:not_found) # HTTP 404
      end
    end
  end
end
