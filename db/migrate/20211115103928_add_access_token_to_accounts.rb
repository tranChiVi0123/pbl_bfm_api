class AddAccessTokenToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :access_token, :string
    add_column :accounts, :refresh_token, :string
  end
end
