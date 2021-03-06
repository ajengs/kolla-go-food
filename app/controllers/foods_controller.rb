class FoodsController < ApplicationController
  skip_before_action :authorize, only: :show
  before_action :set_food, only: [:show, :edit, :update, :destroy]

  # GET /foods
  # GET /foods.json
  def index
    if params[:food]
      @foods = Food.search_by(params[:food])
    else
      @foods = params[:letter].nil? ? Food.all : Food.by_letter(params[:letter])
    end
  end

  # GET /foods/1
  # GET /foods/1.json
  def show
  end

  # GET /foods/new
  def new
    @food = Food.new
  end

  # GET /foods/1/edit
  def edit
  end

  # POST /foods
  # POST /foods.json
  def create
    @food = Food.new(food_params)

    respond_to do |format|
      if @food.save
        format.html { redirect_to @food, notice: 'Food was successfully created.' }
        format.json { render :show, status: :created, location: @food }
      else
        format.html { render :new }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /foods/1
  # PATCH/PUT /foods/1.json
  def update
    respond_to do |format|
      if @food.update(food_params)
        format.html { redirect_to @food, notice: 'Food was successfully updated.' }
        format.json { render :show, status: :ok, location: @food }

        @foods = Food.all.order(:name)
        # ActionCable.server.broadcast 'foods', html: render_to_string('store/index', layout: false)
      else
        format.html { render :edit }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /foods/1
  # DELETE /foods/1.json
  def destroy
    respond_to do |format|
      if @food.destroy
        format.html { redirect_to foods_url, notice: 'Food was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to foods_url, notice: 'Food is in use.' }
        format.json { head :no_content }
      end
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
