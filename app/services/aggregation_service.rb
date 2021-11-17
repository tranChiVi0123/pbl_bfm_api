# frozen_string_literal: true

class AggregationService < ApplicationService
  private_class_method :new

  TOKEN_EMPTY = {
    refresh_token: nil,
    access_token: nil,
    token_expired_at: nil
  }.freeze

  def aggre_account_id_exists?(aggre_account_id)
    aggre_accounts.each do |aggre_account|
      return true if aggre_account['account']['account_id_hash'] == aggre_account_id
    end
    false
  end

  def aggre_accounts
    ApiCaller.call('aggre_accounts', {}, 'GET')
  end

  def generate_access_token(user_id, aggre_account_id)
    token_expired_at = 7.days.from_now
    access_token  = JWT.encode({ user_id: user_id, aggre_account_id: aggre_account_id, exp: token_expired_at.to_i },
                               Rails.application.credentials.secret_key_base, 'HS256')
    refresh_token = JWT.encode({ user_id: user_id, aggre_account_id: aggre_account_id },
                               Rails.application.credentials.secret_key_base, 'HS256')
    {}.tap do |h|
      h[:access_token]     = access_token
      h[:refresh_token]    = refresh_token
      h[:token_expired_at] = token_expired_at
    end
  end

  def refresh_access_token(refresh_token)
    token_expired_at = 7.days.from_now
    hash = JWT.decode(refresh_token, Rails.application.credentials.secret_key_base, 'HS256')
    access_token = JWT.encode({ user_id: hash['user_id'], aggre_account_id: hash['aggre_account_id'], exp: token_expired_at.to_i },
                              Rails.application.credentials.secret_key_base, 'HS256')

    {}.tap do |h|
      h[:access_token]     = access_token
      h[:refresh_token]    = refresh_token
      h[:token_expired_at] = token_expired_at
    end
  rescue StandardError => e
    { errors: e.message }
  end
end
