class Api::V1::HomeController < ApplicationController
    def index
        render json: { message: 'Welcome to lendesk', status: 200 }, status: :ok
    end
end