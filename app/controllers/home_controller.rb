# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    render json: { message: 'Hello World!' }
  end
end
