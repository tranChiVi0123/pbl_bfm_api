# frozen_string_literal: true

class Api::Accounts::AggregationsController < ApplicationController
  before_action :check_valid_aggre_account_id
  def create
    tokens = aggre_service.generate_access_token(current_user.id, params[:aggre_account_id])
    account = Account.new(user_id: current_user.id, aggre_account_id: params[:aggre_account_id],
                          access_token: tokens[:access_token], refresh_token: tokens[:refresh_token])
    if account.save
      render json: tokens
    else
      render json: { errors: [account.errors] }
    end
  end

  private

  def check_valid_aggre_account_id
    unless aggre_service.aggre_account_id_exists?(params[:aggre_account_id])
      render json: { errors: [invalid: "Account's ID not exists!"] }
    end
  end

  def aggre_service
    @aggre_service ||= @aggre_service || AggregationService.instance
  end
end
