class ApplicationController < ActionController::API
  before_action :authenticate_user!


    rescue_from CanCan::AccessDenied do |exception|
        render json: {message: "No tienes acceso a esto"}, status: :forbidden 
       end

end