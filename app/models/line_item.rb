class LineItem < ApplicationRecord
  belongs_to :food
  belongs_to :cart, optional: true
  belongs_to :order, optional: true

  validate :ensure_add_foods_with_same_restaurant

  def total_price
    food.price * quantity
  end

  private
    def ensure_add_foods_with_same_restaurant
      if !cart.line_items.empty? && cart.line_items.first.food.restaurant.id != food.restaurant.id
        errors.add(:base, 'Please choose foods from the same restaurant')
      end
    end
end
