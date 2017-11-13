class AdminController < ApplicationController
  def index
    @number_of_orders = Order.grouped_by_date
    @total_price_per_date = Order.grouped_by_total_price_per_date
    @number_of_orders_per_food = Food.grouped_by_order
    @total_price_per_food = Food.grouped_by_total_price
    @number_of_orders_per_restaurant = Restaurant.grouped_by_order
    @total_price_per_restaurant = Restaurant.grouped_by_total_price
  end
end
