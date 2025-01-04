# app/controllers/users/confirmations_controller.rb
class Users::ConfirmationsController < Devise::ConfirmationsController
    respond_to :json
  
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
  
      if resource.errors.empty?
        sign_in(resource)
        token = current_token
        render json: {
          message: 'Tu cuenta ha sido confirmada exitosamente',
          user: resource,
          token: token
        }
      else
        render json: {
          message: 'Token de confirmación inválido',
          errors: resource.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
  
    private
  
    def current_token
      request.env['warden-jwt_auth.token']
    end
  end