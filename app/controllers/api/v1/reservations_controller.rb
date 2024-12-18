module Api
  module V1
    class ReservationsController < ApplicationController
      before_action :set_reservation, only: %i[show update destroy set_completed]
      before_action :authenticate_user!
      load_and_authorize_resource

     
      def index
        @reservations = Reservation.all
        render json: @reservations
      end

      def reservations_user
        reservations = @current_user.reservations.includes(:vehicle, :user)
        json =  Panko::ArraySerializer.new(
          reservations, each_serializer: ReservationSerializer,
        ).to_a
        render json: json
      end 

     
      def show
        render json: @reservation
      end

      
      def create
         @reservation = Reservation.new(reservation_params)
         @reservation.status_reservation =  :reserved

          if @reservation.save
            @reservation.vehicle.update!(status: :reserved)
            render json: @reservation, status: :created
          else
            render json: @reservation.errors, status: :unprocessable_entity
          end
      end

      def update
        if @reservation.status_reservation ==  "reserved" && @reservation.update(reservation_params)
          render json: @reservation
        else
          render json:  @reservation.errors.full_messages , status: :unprocessable_entity
        end
      end

     
      def destroy
          @reservation.destroy!
          @reservation.vehicle.update!(status: :available)
          render json: @reservation
    
      end


   
      def set_completed
        if @reservation.status_reservation == "reserved"
          @reservation.update!(status_reservation: :completed)
          @reservation.vehicle.update!(status: :available)
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

      def reservation_params
        params.require(:reservation).permit(:user_id,  :vehicle_id, :reservation_date, :refund_date)
      end
    end
  end
end
