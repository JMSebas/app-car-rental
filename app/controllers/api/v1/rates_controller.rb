module Api
  module V1
    class RatesController < ApplicationController
      before_action :set_rate, only: %i[ show update destroy ]
      before_action :authenticate_user!
      load_and_authorize_resource
   
      def index
        @rates = Rate.all

        render json: @rates
      end


      def show
        render json: @rate
      end

      
      def create
        @rate = Rate.new(rate_params)

        if @rate.save
          render json: @rate, status: :created
        else
          render json: @rate.errors, status: :unprocessable_entity
        end
      end

      
      def update
        if @rate.update(rate_params)
          render json: @rate
        else
          render json: @rate.errors, status: :unprocessable_entity
        end
      end

    
      def destroy
        @rate.destroy!
      end

      private
        def set_rate
          @rate = Rate.find(params[:id])
        end

        def rate_params
          params.require(:rate).permit(:car_type, :value_per_day, :season_id)
        end
    end
  end
end