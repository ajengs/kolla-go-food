class Order < ApplicationRecord
  attr_accessor :voucher_code
  has_many :line_items, dependent: :destroy
  belongs_to :voucher, optional: true
  enum payment_type: {
    "Cash" => 0,
    "Go Pay" => 1,
    "Credit Card" => 2
  }

  validates :name, :address, :email, :payment_type, presence: true
  validates :email, format: {
    with: /.+@.+\..+/i,
    message: 'format is invalid'
  }
  validates :payment_type, inclusion: payment_types.keys
  
  validate :ensure_voucher_exists
  validate :voucher_valid_date


  def add_line_items(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def set_total_price
    line_items.reduce(0) { |sum, i| sum + i.total_price }
  end

  def discount
    voucher.discount(total_price)
  end

  def total_after_discount
    total = total_price - discount
    total < 0 ? 0 : total
  end

  def self.search_by(params)
    @orders = Order.where('name LIKE :name AND address LIKE :address AND email LIKE :email',
      { name: "%#{params[:name]}%", 
        address: "%#{params[:address]}%", 
        email: "%#{params[:email]}%" })
    @orders = @orders.where(payment_type: params[:payment_type]) if params[:payment_type].present?
    @orders = @orders.where("total_price >= :min_total_price", { min_total_price: params[:min_total_price] }) if params[:min_total_price].present?
    @orders = @orders.where("total_price <= :max_total_price", { max_total_price: params[:max_total_price] }) if params[:max_total_price].present?
    @orders
  end

  private
    def ensure_voucher_exists
      if !voucher_code.empty?
          voucher = Voucher.find_by(code: voucher_code.upcase)
        if voucher.nil?
          errors.add(:voucher_id, "not found")
        end
      end
    end

    def voucher_valid_date
      if !voucher.nil? && (voucher.valid_from > Date.today || voucher.valid_through < Date.today)
        errors.add(:voucher_id, "no longer valid")
      end
    end
end
