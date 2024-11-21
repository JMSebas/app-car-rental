module Api 
    module V1
        class PaymentTypesController < ApplicationController
            before_action :set_payment_type, only: %i[ show update destroy ]
            before_action :authenticate_user!
            load_and_authorize_resource

           
            def index
            @payment_types = PaymentType.all
        
            render json: @payment_types
            end
        
        
            def show
            render json: @payment_type
            end
        
           
            def create
            @payment_type = PaymentType.new(payment_type_params)
        
            if @payment_type.save
                render json: @payment_type, status: :created
            else
                render json: @payment_type.errors, status: :unprocessable_entity
            end
            end
        
           
            def update
            if @payment_type.update(payment_type_params)
                render json: @payment_type
            else
                render json: @payment_type.errors, status: :unprocessable_entity
            end
            end
        
          
            def destroy
            @payment_type.destroy!
            end
        
            private
        
            def set_payment_type
                @payment_type = PaymentType.find(params[:id])
            end
        
            def payment_type_params
                params.require(:payment_type).permit(:payment_method)
            end
        end
    end

end