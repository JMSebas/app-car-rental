class ApplicationController < ActionController::API
  before_action :authenticate_user!
  before_action :load_and_authorize_resource, unless: :devise_controller?


    rescue_from CanCan::AccessDenied do |exception|
        render json: {message: "No tienes acceso a esto"}, status: :forbidden 
       end

end