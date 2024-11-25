require 'rails_helper'

RSpec.describe "Invoices Integration API", type: :request do
  # Crear un usuario administrador
  let(:admin_user) { create(:admin_user) }

  # Autenticación previa al inicio de las pruebas
  before do
    post '/users/sign_in', params: { user: { email: admin_user.email, password: admin_user.password } }
    token = JSON.parse(response.body).dig('status', 'access_token')
    @auth_headers = { Authorization: "Bearer #{token}" }
  end

  # Configuración de datos
  let(:season) { create(:season, season: 'Summer', start_date: Date.today, end_date: Date.today + 30.days) }
  let(:user) { create(:user) }
  let(:vehicle) { create(:vehicle) }
  let(:reservation) { create(:reservation, user: user, vehicle: vehicle) }
  let(:rate) { create(:rate, season: season, value_per_day: 50.0) }
  let(:payment_type) { create(:payment_type) }
  let(:rental) { create(:rental, reservation: reservation, rate: rate, user: user) }
  let!(:invoices) { create_list(:invoice, 3, payment_type: payment_type, rental: rental) }
  let(:invoice_id) { invoices.first.id }

  # Pruebas para el endpoint GET /api/v1/invoices
  describe "GET /api/v1/invoices" do
    it "retorna una lista de facturas" do
      get '/api/v1/invoices', headers: @auth_headers
      expect(response).to have_http_status(:ok) # HTTP 200
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  # Pruebas para el endpoint GET /api/v1/invoices/:id
  describe "GET /api/v1/invoices/:id" do
    context "cuando la factura existe" do
      it "retorna la factura" do
        get "/api/v1/invoices/#{invoice_id}", headers: @auth_headers
        expect(response).to have_http_status(:ok) # HTTP 200
        expect(JSON.parse(response.body)["id"]).to eq(invoice_id)
      end
    end

    context "cuando la factura no existe" do
      it "retorna un error 404" do
        get "/api/v1/invoices/9999", headers: @auth_headers
        expect(response).to have_http_status(:not_found) # HTTP 404
        expect(JSON.parse(response.body)["error"])
          .to eq("Couldn't find Invoice with 'id'=9999")
      end
    end
  end

  # Pruebas para el endpoint POST /api/v1/invoices
  describe "POST /api/v1/invoices" do
    let(:valid_attributes) do
      {
        invoice: {
          payment_type_id: payment_type.id,
          rental_id: rental.id,
          payment_day: Date.today,
          actual_payment_day: Date.today
        }
      }
    end

    context "con parámetros válidos" do
      it "crea una nueva factura" do
        expect {
          post "/api/v1/invoices", params: valid_attributes, headers: @auth_headers
        }.to change(Invoice, :count).by(1)

        expect(response).to have_http_status(:created) # HTTP 201
      end
    end

    context "con parámetros inválidos" do
      let(:invalid_attributes) { { invoice: { payment_type_id: nil, rental_id: nil } } }

      it "retorna un error 422" do
        post "/api/v1/invoices", params: invalid_attributes, headers: @auth_headers
        expect(response).to have_http_status(:unprocessable_entity) # HTTP 422
        expect(JSON.parse(response.body)["errors"]).not_to be_empty
      end
    end
  end

  # Pruebas para el endpoint PUT /api/v1/invoices/:id
  describe "PUT /api/v1/invoices/:id" do
    let(:valid_attributes) { { invoice: { payment_day: Date.today + 1.day } } }

    context "cuando la factura existe" do
      it "actualiza la factura" do
        put "/api/v1/invoices/#{invoice_id}", params: valid_attributes, headers: @auth_headers
        expect(response).to have_http_status(:ok) # HTTP 200
        updated_invoice = Invoice.find(invoice_id)
        expect(updated_invoice.payment_day).to eq(Date.today + 1.day)
      end
    end

    context "cuando la factura no existe" do
      it "retorna un error 404" do
        put "/api/v1/invoices/9999", params: valid_attributes, headers: @auth_headers
        expect(response).to have_http_status(:not_found) # HTTP 404
      end
    end
  end

  # Pruebas para el endpoint DELETE /api/v1/invoices/:id
  describe "DELETE /api/v1/invoices/:id" do
    context "cuando la factura existe" do
      it "elimina la factura" do
        expect {
          delete "/api/v1/invoices/#{invoice_id}", headers: @auth_headers
        }.to change(Invoice, :count).by(-1)

        expect(response).to have_http_status(:no_content) # HTTP 204
      end
    end

    context "cuando la factura no existe" do
      it "retorna un error 404" do
        delete "/api/v1/invoices/9999", headers: @auth_headers
        expect(response).to have_http_status(:not_found) # HTTP 404
      end
    end
  end
end
