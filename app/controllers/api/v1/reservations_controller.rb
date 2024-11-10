module Api
  module V1
    class ReservationsController < ApplicationController
      before_action :set_reservation, only: %i[show update destroy set_completed]
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

      def create
        if @vehicle.status != 'available'
          return render json: { error: 'El vehículo no está disponible para reservar' }, 
                          status: :unprocessable_entity
        end
      
        if Reservation.exists?(vehicle_id: @vehicle.id, status_reservation: 'in_reserved')
          return render json: { error: 'El vehículo tiene una reservación activa' }, 
                          status: :unprocessable_entity
        end
      
        
        @reservation = Reservation.new(reservation_params)
        @reservation.status_reservation = "in_reserved"
      
        ActiveRecord::Base.transaction do
          if @reservation.save
            @vehicle.update!(status: 'reserved')
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
        if @reservation.status_reservation == 'in_reserved' && @reservation.update(reservation_params)
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
          vehicle.update!(status: 'available')

          render json: @reservation
        end
      end


      # PATCH /reservations/1/set_completed
      def set_completed
        if @reservation.status_reservation == 'in_reserved'
          @reservation.update!(status_reservation: 'completed')
          @reservation.vehicle.update!(status: 'available')
          render json: @reservation, status: :ok
        else
          render json: { error: 'Reserva no está en estado reservado para ser completada' }, 
                 status: :unprocessable_entity
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
        params.require(:reservation).permit(:user_id,  :vehicle_id, :reservation_date, :refund_date)
      end
    end
  end
end
