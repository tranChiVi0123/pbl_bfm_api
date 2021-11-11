# frozen_string_literal: true

class Api::Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user
  def create
    user = User.new(sign_up_params)

    if user.save
      token = user.generate_jwt
      render json: { token: token }, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
