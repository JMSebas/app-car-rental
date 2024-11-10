module Api
  module V1
class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[show update destroy]
  before_action :set_vehicle, only: [:create]

  # GET /reservations
  def index
    @reservations = Reservation.all
    render json: @reservations
  end

  # GET /reservations/1
  def show
    render json: @reservation
  end

  # POST /reservations
  def create
   
    # Validar que el vehículo esté disponible
    unless @vehicle.status == 'available'
      return render json: { error: 'El vehículo no está disponible para reservar' }, 
                    status: :unprocessable_entity
    end

    @reservation = Reservation.new(reservation_params)

    # Usar una transacción para asegurar que tanto la reserva como la actualización del vehículo sean exitosas
    ActiveRecord::Base.transaction do
      if @reservation.save
        # Actualizar el estado del vehículo a 'reserved' o 'unavailable'
        @vehicle.update!(status: 'unavailable')
        
        render json: @reservation, status: :created
      else
        render json: @reservation.errors, status: :unprocessable_entity
      end
    end

  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # PATCH/PUT /reservations/1
  def update
    if @reservation.update(reservation_params)
      render json: @reservation
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reservations/1
  def destroy
    vehicle = @reservation.vehicle
    ActiveRecord::Base.transaction do
      @reservation.destroy!
      # Revisar si no hay más reservaciones activas para este vehículo
      unless vehicle.reservations.where('refundDate > ?', Date.today).exists?
        vehicle.update!(status: 'available')
      end
    end
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def set_vehicle
      @vehicle = Vehicle.find(reservation_params[:vehicle_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Vehículo no encontrado' }, status: :not_found
    end

    def reservation_params
      params.require(:reservation).permit(:user_id, :client_id, :vehicle_id, :reservation_date, :refund_date, :car_status, :rate_id)
    end
end
end
end