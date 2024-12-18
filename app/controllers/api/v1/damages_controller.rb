module Api
  module V1
class DamagesController < ApplicationController
  before_action :set_damage, only: %i[ show update destroy ]

  # GET /damages
  def index
    @damages = Damage.all

    render json: @damages
  end

  # GET /damages/1
  def show
    render json: @damage
  end

  # POST /damages
  def create
    @damage = Damage.new(damage_params)

    if @damage.save
      render json: @damage, status: :created, location: @damage
    else
      render json: @damage.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /damages/1
  def update
    if @damage.update(damage_params)
      render json: @damage
    else
      render json: @damage.errors, status: :unprocessable_entity
    end
  end

  # DELETE /damages/1
  def destroy
    @damage.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_damage
      @damage = Damage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def damage_params
      params.require(:damage).permit(:damage_type, :value, :rental_id)
    end
end
end
end
