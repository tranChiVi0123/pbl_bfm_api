# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #  :recoverable, :rememberable, :validatable
  devise :database_authenticatable, :registerable

  has_many :accounts, dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false }, presence: true, allow_blank: false, format: Devise.email_regexp
  validates :password, presence: true
  validates :password, confirmation: true

  def generate_jwt
    JWT.encode({ id: id, exp: 7.days.from_now.to_i }, Rails.application.credentials.secret_key_base, 'HS256')
  end
end
