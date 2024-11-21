require 'rails_helper'

RSpec.describe "Invoices API", type: :request do
  # Datos iniciales para las pruebas
  let(:season) { Season.create!(season: 'Summer', start_date: Date.today, end_date: Date.today + 30.days) }
  let(:user) { User.create!(email: 'user@example.com', password: 'password123', name: 'John', lastname: 'Doe', role: 0, address: '123 Main St', phone: '0987654321', birthdate: '1990-01-01', username: 'johndoe') }
  let(:vehicle) { Vehicle.create!(brand: 'Toyota', model: 'Corolla', license_plate: 'ABC123', year: 2020, vehicle_type: 'Sedan', status: 0, daily_rate: 50.0) }
  let(:reservation) { Reservation.create!(user_id: user.id, vehicle_id: vehicle.id, reservation_date: Date.today, refund_date: Date.today + 5.days) }
  let(:rate) { Rate.create!(car_type: 'Sedan', value_per_day: 50.0, season_id: season.id) }
  let(:payment_type) { PaymentType.create!(payment_method: 'Credit Card') }
  let(:rental) do
    Rental.create!(
      user_id: user.id,
      reservation_id: reservation.id,
      rate_id: rate.id,
      actual_reservation_date: Date.today,
      expected_refund_date: Date.today + 5.days,
      actual_refund_date: Date.today + 5.days,
      initial_odometer: 0,
      final_odometer: 100,
      car_status: :good,
      car_status_end: :damaged
    )
  end
  let!(:invoices) do
    create_list(:invoice, 3, 
      payment_type: payment_type, 
      rental: rental, 
      tax: 10.5, 
      payment_day: Date.today, 
      actual_payment_day: Date.today
    )
  end
  let(:invoice_id) { invoices.first.id }

  # Pruebas para GET /api/v1/invoices
  describe "GET /api/v1/invoices" do
    before { get '/api/v1/invoices' }

    it "retorna una lista de facturas" do
      expect(response).to have_http_status(:ok) # HTTP 200
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  # Pruebas para GET /api/v1/invoices/:id
  describe "GET /api/v1/invoices/:id" do
    before { get "/api/v1/invoices/#{invoice_id}" }

    context "cuando la factura existe" do
      it "retorna la factura" do
        expect(response).to have_http_status(:ok) # HTTP 200
        expect(JSON.parse(response.body)["id"]).to eq(invoice_id)
      end
    end

    context "cuando la factura no existe" do
      let(:invoice_id) { 9999 }

      it "retorna un error 404" do
        expect(response).to have_http_status(:not_found) # HTTP 404
        expect(JSON.parse(response.body)["error"]).to eq("Invoice not found")
      end
    end
  end

  # Pruebas para POST /api/v1/invoices
  describe "POST /api/v1/invoices" do
    let(:valid_attributes) { { payment_type_id: payment_type.id, rental_id: rental.id, tax: 15.0, payment_day: Date.today, actual_payment_day: Date.today } }

    context "con parámetros válidos" do
      it "crea una nueva factura" do
        expect {
          post "/api/v1/invoices", params: valid_attributes
        }.to change(Invoice, :count).by(1)

        expect(response).to have_http_status(:created) # HTTP 201
      end
    end

    context "con parámetros inválidos" do
      let(:invalid_attributes) { { payment_type_id: nil, rental_id: nil } }

      it "retorna un error 422" do
        post "/api/v1/invoices", params: invalid_attributes

        expect(response).to have_http_status(:unprocessable_entity) # HTTP 422
        expect(JSON.parse(response.body)["errors"]).to include("Payment type must exist", "Rental must exist")
      end
    end
  end

  # Pruebas para PUT /api/v1/invoices/:id
  describe "PUT /api/v1/invoices/:id" do
    let(:valid_attributes) { { tax: 20.0 } }

    context "cuando la factura existe" do
      before { put "/api/v1/invoices/#{invoice_id}", params: valid_attributes }

      it "actualiza la factura" do
        updated_invoice = Invoice.find(invoice_id)
        expect(updated_invoice.tax).to eq(20.0)
        expect(response).to have_http_status(:ok) # HTTP 200
      end
    end

    context "cuando la factura no existe" do
      let(:invoice_id) { 9999 }

      it "retorna un error 404" do
        put "/api/v1/invoices/#{invoice_id}", params: valid_attributes

        expect(response).to have_http_status(:not_found) # HTTP 404
      end
    end
  end

  # Pruebas para DELETE /api/v1/invoices/:id
  describe "DELETE /api/v1/invoices/:id" do
    context "cuando la factura existe" do
      it "elimina la factura" do
        expect {
          delete "/api/v1/invoices/#{invoice_id}"
        }.to change(Invoice, :count).by(-1)

        expect(response).to have_http_status(:no_content) # HTTP 204
      end
    end

    context "cuando la factura no existe" do
      let(:invoice_id) { 9999 }

      it "retorna un error 404" do
        delete "/api/v1/invoices/#{invoice_id}"

        expect(response).to have_http_status(:not_found) # HTTP 404
      end
    end
  end
end
