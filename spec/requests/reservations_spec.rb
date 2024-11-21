# spec/requests/reservations_spec.rb
require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  let(:user) { create(:user) }
  let(:vehicle) { create(:vehicle, status: :available) }
  let(:valid_attributes) {
    {
      user_id: user.id,
      vehicle_id: vehicle.id,
      reservation_date: Date.today,
      refund_date: Date.today + 2.days
    }
  }
  let(:invalid_attributes) {
    {
      user_id: user.id,
      vehicle_id: vehicle.id,
      reservation_date: Date.today,
      refund_date: Date.yesterday  # Invalid, refund_date can't be before reservation_date
    }
  }

  # Verificación de las rutas
  describe "GET /reservations" do
    it "returns a list of reservations" do
      reservation = create(:reservation, user: user, vehicle: vehicle)
      
      get reservations_path  # Esto hace un GET a la ruta de index de reservas
      expect(response).to have_http_status(:success)
      expect(response.body).to include(reservation.id.to_s)
    end
  end

  # Creación de una reserva
  describe "POST /reservations" do
    context "with valid parameters" do
      it "creates a new Reservation" do
        expect {
          post reservations_path, params: { reservation: valid_attributes }
        }.to change(Reservation, :count).by(1)

        expect(response).to redirect_to(reservation_path(Reservation.last))
        follow_redirect!
        expect(response.body).to include("Reservation was successfully created")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Reservation" do
        expect {
          post reservations_path, params: { reservation: invalid_attributes }
        }.to change(Reservation, :count).by(0)

        expect(response).to render_template(:new)
        expect(response.body).to include("Date is invalid bro")  # Error de validación
      end
    end
  end

  # Verificación de la acción show para mostrar una reserva
  describe "GET /reservations/:id" do
    it "returns the reservation" do
      reservation = create(:reservation, user: user, vehicle: vehicle)
      
      get reservation_path(reservation)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(reservation.id.to_s)
    end
  end
end
