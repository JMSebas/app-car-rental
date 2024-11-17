module Api
  module V1
    class InvoicesController < ApplicationController
      before_action :set_invoice, only: %i[ show update destroy ]

      # GET /invoices
      def index
        @invoices = Invoice.all
        render json: @invoices
      end

      # GET /invoices/1
      def show
        render json: @invoice
      end

      # POST /invoices
      def create
        @invoice = Invoice.new(invoice_params)
      
        if @invoice.save
          render json: @invoice, status: :created
        else
          render json: @invoice.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /invoices/1
      def update
        if @invoice.update(invoice_params)
          render json: @invoice
        else
          render json: @invoice.errors, status: :unprocessable_entity
        end
      end

      # DELETE /invoices/1
      def destroy
        @invoice.destroy!
      end

      private
        def set_invoice
          @invoice = Invoice.find(params[:id])
        end

        def invoice_params
          params.require(:invoice).permit(:rental_id, :payment_type_id, :payment_day, :actual_payment_day)
        end

      
    end
  end
end