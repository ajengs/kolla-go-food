class AddGopayToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :gopay, :integer, null: false, default: 200000
  end
end
