module Api
  module V1
    class VehiclesController < ApplicationController
      before_action :set_vehicle, only: [:show, :update, :destroy]
      # GET /api/v1/vehicles
      def index
        @vehicles = filter_vehicles
        render json: @vehicles
      end

      def available
        @available_vehicles = Vehicle.available
        render json: @available_vehicles
      end
      # GET /api/v1/vehicles/1
      def show
        render json: @vehicle
      end
      # POST /api/v1/vehicles
      def create
        @vehicle = Vehicle.new(vehicle_params)
        
        if @vehicle.save
          render json: @vehicle, status: :created
        else
          render json: { errors: @vehicle.errors.full_messages }, 
                 status: :unprocessable_entity
        end
      end
      # PATCH/PUT /api/v1/vehicles/1
      def update
        if @vehicle.update(vehicle_params)
          render json: @vehicle
        else
          render json: { errors: @vehicle.errors.full_messages }, 
                 status: :unprocessable_entity
        end
      end
      # DELETE /api/v1/vehicles/1
      def destroy
        @vehicle.destroy
        head :no_content
      end
      private
      def set_vehicle
        @vehicle = Vehicle.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Vehículo no encontrado' }, status: :not_found
      end
      def vehicle_params
        params.require(:vehicle).permit(
          :brand, 
          :model, 
          :license_plate, 
          :year, 
          :vehicle_type, 
          :status, 
          :daily_rate
        )
      end
      def filter_vehicles
        vehicles = Vehicle.all
        vehicles = vehicles.where(brand: params[:brands]) if params[:brands].present?
        vehicles = vehicles.where(model: params[:models]) if params[:models].present?
        vehicles = vehicles.where(year: params[:years]) if params[:years].present?
        vehicles = vehicles.where(vehicle_type: params[:types]) if params[:types].present?
        vehicles = vehicles.where(status: params[:status]) if params[:status].present?
        if params[:min_price].present? && params[:max_price].present?
          vehicles = vehicles.where(daily_rate: params[:min_price]..params[:max_price])
        end
        # Paginación (opcional, usando la gema 'kaminari' si la tienes instalada)
        vehicles = vehicles.page(params[:page]).per(params[:per_page]) if params[:page].present?
        vehicles
      end
    end
  end
end

