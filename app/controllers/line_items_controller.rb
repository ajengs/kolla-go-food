class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]

  def create
    food = Food.find(params[:food_id])
    @line_item = @cart.add_food(food)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_index_path, notice: 'Line item was successfully added' }
        format.js
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end
end
