# frozen_string_literal: true

class Api::AccountsController < ApplicationController
  def index
    aggre_account_ids = current_user.accounts.pluck(:aggre_account_id)
    render json: aggre_service.get_aggre_accounts_by_id(aggre_account_ids)
  end

  private

  def aggre_service
    @aggre_service ||= @aggre_service || AggregationService.instance
  end
end
