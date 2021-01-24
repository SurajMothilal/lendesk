class ApplicationController < ActionController::API
    before_action :authenticate_user
    attr_reader :current_user
   
    private
   
    def authenticate_user
       @current_user = AuthorizeUser.call(request.headers).result
       render json: { error: 'Unauthorized', status: 401 }, status: 401 unless @current_user
    end
end