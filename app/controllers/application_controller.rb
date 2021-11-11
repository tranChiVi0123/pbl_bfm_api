# frozen_string_literal: true

class ApplicationController < ActionController::API
  respond_to :json

  # before_action :underscore_params!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end

  def authenticate_user
    token = request.headers[:Authorization]&.split&.last
    jwt_payload = JWT.decode(token, Rails.application.credentials.secret_key_base, 'HS256').first
    return render json: { errors: [:expired] }, status: :unauthorized if jwt_payload['exp'] < Time.current.to_i

    @current_user_id = jwt_payload['id']
  rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
    head :unauthorized
    render json: { errors: [:unauthorized] }, status: :unauthorized
  end

  def authenticate_user!(_options = {})
    head :unauthorized unless signed_in?
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end
end
