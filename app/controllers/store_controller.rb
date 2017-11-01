class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart

  def index
    @foods = Food.order(:name)
  end
end
