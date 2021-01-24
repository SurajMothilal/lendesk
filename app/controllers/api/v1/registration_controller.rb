class Api::V1::RegistrationController < ApplicationController
  skip_before_action :authenticate_user

  def register
    command = RegisterUser.call(signup_params)
  
    if command.success?
      render json: { auth_token: command.result, status: 201 }, status: :created
    else
      render json: { error: command.errors, status: 401 }, status: :unauthorized
    end
  end

  private

  def signup_params
      params.permit(:username, :password)
  end
end