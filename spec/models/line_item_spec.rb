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
end