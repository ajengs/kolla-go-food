class Api::V1::FoodsController < ApplicationController
  skip_before_action :authorize
  before_action :set_food, only: [:show, :edit, :update, :destroy]

  # GET /foods.json
  def index
    if params[:food]
      @foods = Food.search_by(params[:food])
    else
      @foods = params[:letter].nil? ? Food.all : Food.by_letter(params[:letter])
    end
    render json: @foods
  end

  # GET /foods/1.json
  def show
    render json: @food
  end

  # POST /foods.json
  def create
    @food = Food.new(food_params)

    if @food.save
      render json: @food
    else
      render json: @food.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @food = Food.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_params
      params.require(:food).permit(:name, :description, :image_url, :price,
        :category_id, :restaurant_id,
        tag_ids: [])
    end
end
