module Api
  module V1
    class ReparationsController < ApplicationController
      before_action :set_reparation, only: %i[show update destroy]
      before_action :set_vehicle, only: %i[create]
      before_action :authenticate_user!
      load_and_authorize_resource

     
      def index
        @reparations = Reparation.all
        render json: @reparations
      end

   
      def show
        render json: @reparation
      end

     
      def create
        if @vehicle.status == 'reserved'
          render json: { error: 'El vehículo está reservado y no puede ser puesto en reparación' }, status: :unprocessable_entity
          return
        end

        @reparation = Reparation.new(reparation_params)

        if @reparation.save
          @vehicle.update(status: 4)
          render json: @reparation, status: :created
        else
          render json: @reparation.errors, status: :unprocessable_entity
        end
      end

   
      def update
        if @reparation.update(reparation_params)
          render json: @reparation
        else
          render json: @reparation.errors, status: :unprocessable_entity
        end
      end

    
      def destroy
        render json: @reparation.vehicle.update(status: 'available') if @reparation.destroy
        
      end

      private

      def set_reparation
        @reparation = Reparation.find(params[:id])
      end

      def set_vehicle
        @vehicle = Vehicle.find(reparation_params[:vehicle_id])
      end

      def reparation_params
        params.require(:reparation).permit(:vehicle_id, :entry_day, :exit_day)
      end
    end
  end
end
