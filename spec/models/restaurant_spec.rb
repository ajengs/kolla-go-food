require 'rails_helper'

describe Restaurant do
  it 'has a valid factory' do
    expect(build(:restaurant)).to be_valid
  end

  it 'is valid with name & address' do
    expect(build(:restaurant)).to be_valid
  end

  it 'is valid without a name' do
    restaurant = build(:restaurant, name: nil)
    restaurant.valid?
    expect(restaurant.errors[:name]).to include("can't be blank")
  end

  it 'is valid without a address' do
    restaurant = build(:restaurant, address: nil)
    restaurant.valid?
    expect(restaurant.errors[:address]).to include("can't be blank")
  end

  it 'is invalid with duplicate name' do
    restaurant1 = create(:restaurant, name:'sari rasa')
    restaurant2 = build(:restaurant, name: 'sari rasa')
    restaurant2.valid?
    expect(restaurant2.errors[:name]).to include('has already been taken')
  end

  it "can't be destroyed while it has food(s)" do
    restaurant = create(:restaurant)
    food = create(:food, restaurant: restaurant)
    expect{ restaurant.destroy }.not_to change(Restaurant, :count)
  end

  describe 'adding review' do
    it 'saves review with restaurant' do
      restaurant = create(:restaurant)
      review = create(:review, reviewable: restaurant)
      restaurant.reload
      expect(restaurant.reviews).to match_array(review)
    end
  end
end
