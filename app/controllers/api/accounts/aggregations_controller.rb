# frozen_string_literal: true

class Api::Accounts::AggregationsController < ApplicationController
  before_action :otp_valid?

  def create
    res = aggre_service.generate_access_token(current_user.id, oauth_params)
    account = Account.new(user_id: current_user.id, aggre_account_id: res[:aggre_account_id],
                          access_token: res[:access_token], refresh_token: res[:refresh_token])

    if account.save
      render json: account, status: :ok
    else
      render json: { errors: account.errors }, status: :bad_request
    end
  end

  private

  def otp_valid?
    render json: { errors: 'OTP not exists!' }, status: :bad_request unless aggre_service.otp_exists?(oauth_params[:otp])
  end

  def aggre_service
    @aggre_service ||= @aggre_service || AggregationService.instance
  end

  def oauth_params
    params.require(:oauth).permit(:otp)
  end
end
