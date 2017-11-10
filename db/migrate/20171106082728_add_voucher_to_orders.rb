class AddVoucherToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :voucher, foreign_key: true
  end
end
