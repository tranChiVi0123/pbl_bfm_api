# frozen_string_literal: true

class ApiCaller < ApiBase
  API_URL = ENV['API_URL']
  def initialize
    @api_url = API_URL
  end

  def call(endpoint, data = {}, _method = 'GET')
    conn = Faraday.new(
      url: @api_url,
      params: data,
      headers: { 'Content-Type' => 'application/json' }
    )
    res = conn.get(endpoint) do |req|
      req.params = data
    end
    JSON.parse(res.body)
  rescue StandardError => e
    { errors: e.message }
  end
end
