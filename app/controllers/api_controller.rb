class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_default_format
  before_action :authenticate_user!
  
  private
  
    def set_default_format
      request.format = :json
    end

    def authenticate_token!
      payload = JsonWebToken.decode(auth_token)
      @current_user = User.find(payload['sub'])
    rescue JWT::ExpiredSignature
      render json: {errors: ['Auth token has expired']}, status: :unanthorized
    rescue JWT::DecodeError
      render json: {errors: ['Invalind auth token']}, status: :unanthorized
    end

    def auth_token
      @auth_token ||= request.headers.fetch('Authorization', '').split(' ').last
    end
end