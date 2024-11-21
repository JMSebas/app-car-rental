require 'rails_helper'

RSpec.describe "Invoices API", type: :request do
  # Datos iniciales para las pruebas
  let!(:invoices) { create_list(:invoice, 5) } # Crear 5 facturas
  let(:invoice_id) { invoices.first.id } # ID de la primera factura

  # Pruebas para GET /api/v1/invoices
  describe "GET /api/v1/invoices" do
    before { get '/api/v1/invoices' }

    it "retorna una lista de facturas" do
      expect(response).to have_http_status(:ok) # HTTP 200
      expect(JSON.parse(response.body).size).to eq(5)
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
      let(:invoice_id) { 9999 } # ID inexistente

      it "retorna un error 404" do
        expect(response).to have_http_status(:not_found) # HTTP 404
        expect(JSON.parse(response.body)["error"]).to eq("Invoice not found")
      end
    end
  end

  # Pruebas para POST /api/v1/invoices
  describe "POST /api/v1/invoices" do
    let(:valid_attributes) { { customer_name: "John Doe", total_amount: 100.0, status: "paid" } }

    context "con parámetros válidos" do
      it "crea una nueva factura" do
        expect {
          post "/api/v1/invoices", params: valid_attributes
        }.to change(Invoice, :count).by(1)

        expect(response).to have_http_status(:created) # HTTP 201
      end
    end

    context "con parámetros inválidos" do
      let(:invalid_attributes) { { customer_name: nil, total_amount: nil } }

      it "retorna un error" do
        post "/api/v1/invoices", params: invalid_attributes

        expect(response).to have_http_status(:unprocessable_entity) # HTTP 422
        expect(JSON.parse(response.body)["errors"]).to include("Customer name can't be blank", "Total amount can't be blank")
      end
    end
  end

  # Pruebas para PUT /api/v1/invoices/:id
  describe "PUT /api/v1/invoices/:id" do
    let(:valid_attributes) { { total_amount: 150.0 } }

    context "cuando la factura existe" do
      before { put "/api/v1/invoices/#{invoice_id}", params: valid_attributes }

      it "actualiza la factura" do
        updated_invoice = Invoice.find(invoice_id)
        expect(updated_invoice.total_amount).to eq(150.0)
        expect(response).to have_http_status(:ok) # HTTP 200
      end
    end

    context "cuando la factura no existe" do
      let(:invoice_id) { 9999 } # ID inexistente

      it "retorna un error 404" do
        put "/api/v1/invoices/#{invoice_id}", params: valid_attributes

        expect(response).to have_http_status(:not_found) # HTTP 404
        expect(JSON.parse(response.body)["error"]).to eq("Invoice not found")
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
      let(:invoice_id) { 9999 } # ID inexistente

      it "retorna un error 404" do
        delete "/api/v1/invoices/#{invoice_id}"

        expect(response).to have_http_status(:not_found) # HTTP 404
        expect(JSON.parse(response.body)["error"]).to eq("Invoice not found")
      end
    end
  end
end
