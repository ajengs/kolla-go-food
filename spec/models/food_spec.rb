require 'rails_helper'

describe Food do
  it 'is valid with a name and description' do
    food = Food.new(
      name: 'Sate Ayam',
      description: 'Sate yang dibuat dari daging ayam',
      price: 30000.0
    )
    expect(food).to be_valid
  end

  it 'is invalid without a name' do
    food = Food.new(
      name: nil,
      description: 'Sate yang dibuat dari daging ayam',
      price: 30000.0
    )
    food.valid?
    expect(food.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without a description' do
    food = Food.new(
      name: 'Sate Ayam',
      description: nil,
      price: 30000.0
    )
    food.valid?
    expect(food.errors[:description]).to include("can't be blank")
  end

  it 'is invalid with a duplicate name' do
    food1 = Food.create(
      name: 'Sate Ayam',
      description: 'Sate yang dibuat dari daging ayam',
      price: 30000.0
    )

    food2 = Food.new(
      name: 'Sate Ayam',
      description: 'Sate yang dibuat dari daging ayam loh',
      price: 30000.0
    )

    food2.valid?
    expect(food2.errors[:name]).to include("has already been taken")
  end
end