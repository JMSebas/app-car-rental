# app/controllers/users/passwords_controller.rb
class Users::PasswordsController < Devise::PasswordsController
    respond_to :json
    
    
    def create
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      
      if successfully_sent?(resource)
        render json: {
          status: { 
            code: 200, 
            message: 'Reset password instructions have been sent to your email'
          }
        }, status: :ok
      else
        render json: {
          status: { 
            code: 422, 
            message: 'Error sending reset instructions',
            errors: resource.errors.full_messages 
          }
        }, status: :unprocessable_entity
      end
    end
  
    def update
      self.resource = resource_class.reset_password_by_token(resource_params)
  
      if resource.errors.empty?
        render json: {
          status: { 
            code: 200, 
            message: 'Password has been successfully reset'
          }
        }, status: :ok
      else
        render json: {
          status: { 
            code: 422, 
            message: 'Error resetting password',
            errors: resource.errors.full_messages 
          }
        }, status: :unprocessable_entity
      end
    end
  end