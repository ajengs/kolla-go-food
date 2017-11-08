class OrdersController < ApplicationController
  include CurrentCart
  skip_before_action :authorize, only: [:new, :create, :show]
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :ensure_cart_isnt_empty, only: :new
  before_action :ensure_voucher_exists, only: :create

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    @order.add_line_items(@cart)
    @order.voucher = !params[:voucher_code].nil? ? Voucher.find_by(code: params[:voucher_code].upcase) : nil

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil

        OrderMailer.received(@order).deliver_later

        format.html { redirect_to @order, notice: 'Thank you for your order' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated' }
        format.json { render :show, status: :updated, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_path, notice: 'Order was successfully destroyed' }
      format.json { head :no_content}
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:name, :email, :address, :payment_type, :voucher_id)
    end

    def ensure_cart_isnt_empty
      if @cart.line_items.empty?
        redirect_to store_index_path, notice: 'Your cart is empty.'
      end
    end

    def ensure_voucher_exists
      if !params[:voucher_code].nil?
          voucher = Voucher.find_by(code: params[:voucher_code].upcase)
        if voucher.nil?
          render :new, notice: 'Voucher not found'
        end
      end
    end
end
