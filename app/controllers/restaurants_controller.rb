class RestaurantsController < ApplicationController
  skip_before_action :authorize, only: :show
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

  # GEt /restaurants
  # GET /restaurants.json
  def index
    @restaurants = Restaurant.all
  end

  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
  end
  
  # GET /foods/new
  def new
    @restaurant = Restaurant.new
  end
  
  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    @restaurant = Restaurant.new(restaurant_params)

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    respond_to do |format|
      if @restaurant.destroy
        format.html { redirect_to restaurants_path, notice: 'Restaurant was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to restaurants_path, notice: 'Restaurant is in use. Cannot be destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    def restaurant_params
      params.require(:restaurant).permit(:name, :address)
    end
end
