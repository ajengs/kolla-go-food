class LineItem < ApplicationRecord
  belongs_to :food
  belongs_to :cart, optional: true
  belongs_to :order, optional: true

  def total_price
    food.price * quantity
  end
end
