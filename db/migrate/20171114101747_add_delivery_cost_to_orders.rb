class AddDeliveryCostToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :delivery_cost, :float
  end
end
