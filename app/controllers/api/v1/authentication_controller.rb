class Api::V1::AuthenticationController < ApplicationController
    skip_before_action :authenticate_user

    def authenticate
      command = AuthenticateUser.call(signin_params)
    
      if command.success?
        render json: { auth_token: command.result, status: 200 }, status: :ok
      else
        render json: { error: command.errors, status: 401 }, status: :unauthorized
      end
    end
  
    private
  
    def signin_params
        params.permit(:username, :password)
    end
  end