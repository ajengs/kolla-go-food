class StoreController < ApplicationController
  include CurrentCart
  skip_before_action :authorize
  before_action :set_cart

  def index
    # @foods = Food.order(:name)
    @restaurants = Restaurant.order(:name)
  end
end
