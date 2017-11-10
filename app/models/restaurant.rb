class Restaurant < ApplicationRecord
  has_many :foods
  has_many :reviews, as: :reviewable
  validates :name, :address, presence: true
  validates :name, uniqueness: true
  before_destroy :ensure_not_referenced_by_any_food

  def self.search_by(params)
    @restaurants = Restaurant.where('restaurants.name LIKE :name AND restaurants.address LIKE :address',
      { name: "%#{params[:name]}%", 
        address: "%#{params[:address]}%"
      }
    )

    if !params[:min_food].empty? && !params[:max_food].empty?
      @restaurants = @restaurants.joins(:foods).group(:restaurant_id).having("count(restaurant_id) BETWEEN ? AND ?", params[:min_food].to_i, params[:max_food].to_i)
    elsif !params[:min_food].empty?
      @restaurants = @restaurants.joins(:foods).group(:restaurant_id).having("count(restaurant_id) >= ?", params[:min_food].to_i)
    elsif !params[:max_food].empty?
      @restaurants = @restaurants.joins(:foods).group(:restaurant_id).having("count(restaurant_id) <= ?", params[:max_food].to_i)         
    end
    @restaurants
  end

  private
    def ensure_not_referenced_by_any_food
      unless foods.empty?
        errors.add(:base, 'Foods present')
        throw :abort
      end
    end  
end
