class Order < ApplicationRecord
  attr_accessor :voucher_code
  has_many :line_items, dependent: :destroy
  belongs_to :voucher, optional: true
  belongs_to :user

  enum payment_type: {
    "Cash" => 0,
    "Go Pay" => 1,
    "Credit Card" => 2
  }
  geocoded_by :address
  before_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  before_validation :set_calculated_attributes

  validates :name, :address, :email, :payment_type, presence: true
  validates :email, format: {
    with: /.+@.+\..+/i,
    message: 'format is invalid'
  }
  validates :payment_type, inclusion: payment_types.keys
  
  validate :ensure_voucher_exists
  validate :voucher_valid_date
  validate :ensure_credit_sufficient_if_using_gopay

  validate :ensure_address_latlong_found
  validate :distance_must_be_less_than_or_equal_to_max_dist
  
  before_save :substracts_credit_if_using_gopay

  scope :grouped_by_date, -> { group_by_day(:created_at).count }
  scope :grouped_by_total_price_per_date, -> { group("strftime('%Y-%m-%d', orders.created_at)").sum(:total_price) }
  
  def cost_per_km
    1500
  end

  def max_dist
    25
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

  def add_line_items(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def total_price_before_discount
    line_items.reduce(0) { |sum, i| sum + i.total_price } + calculate_delivery_cost
  end

  def discount
    voucher.discount(total_price_before_discount)
  end

  def calculate_total_price
    total = voucher.nil? ? total_price_before_discount : total_price_before_discount - discount
    total < 0 ? 0 : total
  end

  def calculate_distance
    dist = 0
    if geocoder_attributes_exist?
      dist = self.distance_from(line_items.first.food.restaurant.to_coordinates).round(2)
    end
    dist
  end

  def calculate_delivery_cost
    cost = 0
    cost = (cost_per_km * calculate_distance).round
    cost
  end

  private
    def ensure_voucher_exists
      if !voucher_code.nil?
        voucher = Voucher.find_by(code: voucher_code.upcase) if !voucher_code.empty?
        if voucher.nil? && !voucher_code.empty?
          errors.add(:voucher_id, "not found")
        end
      end
    end

    def voucher_valid_date
      if !voucher.nil? && (voucher.valid_from > Date.today || voucher.valid_through < Date.today)
        errors.add(:voucher_id, "no longer valid")
      end
    end

    def ensure_credit_sufficient_if_using_gopay
      if payment_type == 'Go Pay'
        if user.gopay < total_price
          errors.add(:payment_type, ': insufficient Go Pay credit')
        end
      end
    end

    def substracts_credit_if_using_gopay
      if payment_type == 'Go Pay'
        user.gopay -= total_price
        user.save
      end
    end

    def set_calculated_attributes
      self.delivery_cost = calculate_delivery_cost
      self.total_price = calculate_total_price
    end

    def ensure_address_latlong_found
      if latitude.blank? || longitude.blank?
        errors.add(:address, "not found")
      end
    end

    def distance_must_be_less_than_or_equal_to_max_dist
      if calculate_distance > max_dist
        errors.add(:address, "must not be more than #{max_dist} km away from restaurant")
      end
    end

    def geocoder_attributes_exist?
      !latitude.blank? && !longitude.blank? && !line_items.first.nil?
    end
end
