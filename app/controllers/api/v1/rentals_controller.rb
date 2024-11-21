module Api
  module V1
class RentalsController < ApplicationController
  before_action :set_rental, only: %i[ show update destroy ]
  load_and_authorize_resource


  def index
    @rentals = Rental.all

    render json: @rentals
  end

  
  def show
    render json: @rental
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
    if @rental.update(rental_params)
      render json: @rental
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
      params.require(:rental).permit(:user_id, :reservation_id, :actual_reservation_date, :expected_refund_date, :actual_refund_date, :car_status, :initial_odometer, :final_odometer, :rate_id)
    end
end
end
end