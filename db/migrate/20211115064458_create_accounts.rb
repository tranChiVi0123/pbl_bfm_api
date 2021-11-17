class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :aggre_account_id
      t.integer :user_id
      t.integer :status, :default => 0

      t.timestamps
    end
  end
end
