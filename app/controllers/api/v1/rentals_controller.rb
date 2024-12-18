module Api
  module V1
class RentalsController < ApplicationController
  before_action :set_rental, only: %i[ show update destroy ]
  before_action :authenticate_user!
  load_and_authorize_resource


  def index
    @rentals = Rental.all

    render json: @rentals
  end

  def rentals_user 
      rentals = @current_user.rentals
      render json: Panko::ArraySerializer.new(rentals, each_serializer: RentalSerializer).to_json
  
  end

  
  def show
    render json: RentalSerializer.new.serialize(@rental)
  end

  
  def create
    @rental = Rental.new(rental_params)

    if @rental.save
      render json: @rental, status: :created
    else
      render json: @rental.errors, status: :unprocessable_entity
    end
  end


  def update
    if @rental.update(rental_params.except(:damages))
      if params[:rental][:damages].present?
        params[:rental][:damages].each do |damage|
          # Crear nuevo damage asociado al rental actual
          @rental.damages.create(
            damage_type: damage[:damage_type],
            value: damage[:value]
          )
        end
      end
      render json: @rental, status: :ok
    else
      render json: @rental.errors, status: :unprocessable_entity
    end
  end
  


  def destroy
    @rental.destroy!
  end

  private

    def set_rental
      @rental = Rental.find(params[:id])
    end

    def rental_params
      if action_name == 'create'
        # Para crear: solo permitir los campos básicos del rental
        params.require(:rental).permit(
          :reservation_id, 
          :actual_refund_date, 
          :car_status, 
          :initial_odometer, 
          :final_odometer, 
          :rate_id
        )
      else
        # Para actualizar: permitir los campos básicos y el array de damages
        params.require(:rental).permit(
          :reservation_id, 
          :actual_refund_date, 
          :car_status, 
          :initial_odometer, 
          :final_odometer, 
          :rate_id,
          damages: [:damage_type, :value]
        )
      end
    end    
    
end
end
end