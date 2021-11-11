# frozen_string_literal: true

class Api::Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user

  def create
    user = User.find_by(email: sign_in_params[:email])

    if user&.valid_password?(sign_in_params[:password])
      token = user.generate_jwt
      render json: { token: token }, status: :ok
    else
      render json: 'Invalid email or password', status: :unprocessable_entity
    end
  end

  private

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end
end
