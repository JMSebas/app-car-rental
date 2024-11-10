# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :lastname, :address, :phone, :birthdate, :username, :email, :password, :role])
    # Si necesitas permitir más parámetros para la actualización de la cuenta, descomenta la siguiente línea
    # devise_parameter_sanitizer.permit(:account_update, keys: [:name, :lastname, :address, :phone, :birthdate, :username])
  end

  def respond_with(resource, options = {})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up successfully', data: resource }
      }, status: :ok
    else
      Rails.logger.debug(resource.errors.full_messages)  
      render json: {
        status: { message: 'User could not be created successfully', errors: resource.errors.full_messages },
      }, status: :unprocessable_entity
    end
  end
end
