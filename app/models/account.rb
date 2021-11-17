# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user

  validates :aggre_account_id, uniqueness: { scope: :user_id }
end
