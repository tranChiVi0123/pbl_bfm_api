# frozen_string_literal: true

class AggregationService < ApplicationService
  private_class_method :new

  TOKEN_EMPTY = {
    refresh_token: nil,
    access_token: nil,
    token_expired_at: nil
  }.freeze

  def otp_exists?(otp_value)
    oauth[otp_value] ? true : false
  end

  def oauth
    ApiCaller.call('oauth', {}, 'GET')
  end

  def aggre_accounts
    ApiCaller.call('aggre_accounts', {}, 'GET')
  end

  def transactions
    ApiCaller.call('transactions', {}, 'GET')
  end

  def all_otp
    oauth.keys.to_json
  end

  def get_aggre_accounts_by_id(aggre_account_ids)
    aggre_accounts.select { |aggre_account| aggre_account_ids.include?(aggre_account['account']['account_id_hash']) }
  end

  def get_transactions_by_id(aggre_account_ids)
    transactions.select { |aggre_account| aggre_account_ids.include?(aggre_account['transaction']['hashed_account_id']) }
  end

  def generate_access_token(user_id, oauth_params)
    token_expired_at = 7.days.from_now
    access_token  = JWT.encode({ user_id: user_id, otp: oauth_params[:otp], exp: token_expired_at.to_i },
                               Rails.application.credentials.secret_key_base, 'HS256')
    refresh_token = JWT.encode({ user_id: user_id, otp: oauth_params[:otp] },
                               Rails.application.credentials.secret_key_base, 'HS256')
    {}.tap do |h|
      h[:access_token]     = access_token
      h[:refresh_token]    = refresh_token
      h[:token_expired_at] = token_expired_at
      h[:aggre_account_id] = oauth[oauth_params[:otp]]['account_id_hash']
    end
  end

  def refresh_access_token(refresh_token)
    token_expired_at = 7.days.from_now
    hash = JWT.decode(refresh_token, Rails.application.credentials.secret_key_base, 'HS256')
    access_token = JWT.encode({ user_id: hash['user_id'], otp: oauth_params[:otp], exp: token_expired_at.to_i },
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
