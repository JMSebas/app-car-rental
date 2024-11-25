class ApplicationController < ActionController::API
  


    rescue_from CanCan::AccessDenied do |exception|
        render json: {message: "You don't have access to this"}, status: :forbidden 
       end

end