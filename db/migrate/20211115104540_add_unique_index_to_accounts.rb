class AddUniqueIndexToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_index :accounts, [:user_id, :aggre_account_id], unique: true
  end
end
