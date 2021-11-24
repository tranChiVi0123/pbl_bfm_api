# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    render json: aggre_service.all_otp
  end

  private

  def aggre_service
    @aggre_service ||= @aggre_service || AggregationService.instance
  end
end
