require 'rails_helper'

RSpec.describe Cart, type: :model do
  it 'has a valid factory' do
    expect(build(:cart)).to be_valid
  end

  it 'deletes line_items when deleted' do
    cart = create(:cart)
    restaurant = create(:restaurant)
    food1 = create(:food, restaurant: restaurant)
    food2 = create(:food, restaurant: restaurant)

    line_item1 = create(:line_item, cart: cart, food: food1)
    line_item2 = create(:line_item, cart: cart, food: food2)
    cart.line_items << line_item1
    cart.line_items << line_item2

    expect { cart.destroy }.to change { LineItem.count }.by(-2)
  end

  it 'does not change the number of line item if the same food is added' do
    cart = create(:cart)
    food = create(:food)
    line_item = create(:line_item, food: food, cart: cart)
    
    expect { cart.add_food(food) }.not_to change(LineItem, :count)
  end

  it 'increments the quantity of line item if the same food is added' do
    cart = create(:cart)
    food = create(:food)
    line_item = create(:line_item, food: food, cart: cart)
    
    # expect { cart.add_food(food) }.to change { line_item.quantity }.by(1)
    expect(cart.add_food(food).quantity).to eq(2)
  end

  it 'can return total of subtotal price from all line items' do
    cart = create(:cart)
    restaurant = create(:restaurant)
    food1 = create(:food, price: 5000, restaurant: restaurant)
    line_item1 = create(:line_item, food: food1, cart: cart, quantity: 2)
    food2 = create(:food, price: 10000, restaurant: restaurant)
    line_item2 = create(:line_item, food: food2, cart: cart)

    expect(cart.total_price).to eq(20000)
  end
end
