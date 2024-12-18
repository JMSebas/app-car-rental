module Api
    module V1
        class UsersController < ApplicationController

            before_action :set_user, only: %i[ show ]
            before_action :authenticate_user!
            load_and_authorize_resource
            
            def index 
                users = User.all
                render json: Panko::ArraySerializer.new(
                    users,
                    each_serializer: UserSerializer
                ).to_json
                end

            def show
                render json: @user
            end

            def set_user
                @user = User.find(params[:id])
            end

        end     
    end
end