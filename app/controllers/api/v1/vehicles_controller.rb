module Api
  module V1
    class VehiclesController < ApplicationController
      before_action :set_vehicle, only: [:show, :update, :destroy]
      load_and_authorize_resource
     
      
      def index
        @vehicles = filter_vehicles
        render json: @vehicles
      end

      def available
        @available_vehicles = Vehicle.available
        render json: @available_vehicles
      end

      
      def show
        render json: @vehicle
      end

      def create
        @vehicle = Vehicle.new(vehicle_params.merge(status: :available))
        
        if @vehicle.save
          render json: @vehicle, status: :created
        else
          render json: { errors: @vehicle.errors.full_messages }, 
                 status: :unprocessable_entity
        end
      end

      def update
        if @vehicle.update(vehicle_params)
          render json: @vehicle
        else
          render json: { errors: @vehicle.errors.full_messages }, 
                 status: :unprocessable_entity
        end
      end

      def destroy
       render json: @vehicle.destroy
        
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
        vehicles = Vehicle.all.available
        vehicles = vehicles.where(brand: params[:brands]) if params[:brands].present?
        vehicles = vehicles.where(model: params[:models]) if params[:models].present?
        vehicles = vehicles.where(year: params[:years]) if params[:years].present?
        vehicles = vehicles.where(vehicle_type: params[:types]) if params[:types].present?
        if params[:min_price].present? && params[:max_price].present?
          vehicles = vehicles.where(daily_rate: params[:min_price]..params[:max_price])
        end

        vehicles = vehicles.page(params[:page]).per(params[:per_page]) if params[:page].present?
        vehicles
      end
    end
  end
end

