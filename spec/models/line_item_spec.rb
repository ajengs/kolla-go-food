require 'rails_helper'

describe LineItem do
  it 'has a valid factory' do
    expect(build(:line_item)).to be_valid
  end

  it 'returns the total price of foods per line_item' do
    food = create(:food, price: 6000)
    cart = create(:cart)
    line_item = create(:line_item, cart: cart, food: food)
    cart.add_food(food)
    line_item.reload

    expect(line_item.total_price).to eq(12000)
  end
end