module Api
  module V1
class ReparationsController < ApplicationController
  before_action :set_reparation, only: %i[ show update destroy ]

  # GET /reparations
  def index
    @reparations = Reparation.all

    render json: @reparations
  end

  # GET /reparations/1
  def show
    render json: @reparation
  end

  # POST /reparations
  def create
    @reparation = Reparation.new(reparation_params)

    if @reparation.save
      render json: @reparation, status: :created
    else
      render json: @reparation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reparations/1
  def update
    if @reparation.update(reparation_params)
      render json: @reparation
    else
      render json: @reparation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reparations/1
  def destroy
    @reparation.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reparation
      @reparation = Reparation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reparation_params
      params.require(:reparation).permit(:vehicle_id, :enty_day, :exit_day)
    end
end
end
end