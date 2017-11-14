require 'rails_helper'

describe LineItem do
  it 'has a valid factory' do
    expect(build(:line_item)).to be_valid
  end

  it 'returns the total price of foods per line_item' do
    food = create(:food, price: 6000)
    line_item = create(:line_item, food: food, quantity: 3)

    expect(line_item.total_price).to eq(18000)
  end

  it 'does not save foods to line item from different restaurant' do
    restaurant1 = create(:restaurant)
    restaurant2 = create(:restaurant)
    food1 = create(:food, restaurant: restaurant1)
    food2 = create(:food, restaurant: restaurant2)
    cart = create(:cart)
    line_item = create(:line_item, food: food1, cart: cart)
    line_item2 = build(:line_item, food: food2, cart: cart)

    line_item2.valid?
    expect(line_item2.errors[:base]).to include('Please choose foods from the same restaurant')
  end
end