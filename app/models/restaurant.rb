class Restaurant < ApplicationRecord
  has_many :foods
  has_many :reviews, as: :reviewable
  
  geocoded_by :address
  before_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  validates :name, :address, presence: true
  validates :name, uniqueness: true
  validate :ensure_address_latlong_found
  before_destroy :ensure_not_referenced_by_any_food

  scope :grouped_by_order, -> { joins(foods: { line_items: :order }).group("restaurants.name").count }
  scope :grouped_by_total_price, -> { joins(foods: { line_items: :order }).group("restaurants.name").sum("orders.total_price") }
  

  def self.search_by(params)
    restaurants = Restaurant.where('restaurants.name LIKE :name AND restaurants.address LIKE :address',
      { name: "%#{params[:name]}%", 
        address: "%#{params[:address]}%"
      }
    )

    restaurants = restaurants.joins(:foods).group(:restaurant_id).having("count(restaurant_id) >= ?", params[:min_food].to_i) if self.valid_search_params?params[:min_food]
    restaurants = restaurants.joins(:foods).group(:restaurant_id).having("count(restaurant_id) <= ?", params[:max_food].to_i) if self.valid_search_params?params[:max_food]
    restaurants
  end

  def self.valid_search_params?(params)
    params.present? && !params.blank?
  end

  private
    def ensure_not_referenced_by_any_food
      unless foods.empty?
        errors.add(:base, 'Foods present')
        throw :abort
      end
    end

    def ensure_address_latlong_found
      if latitude.nil? || longitude.nil?
        errors.add(:address, "not found")
      end
    end
end
