require 'rails_helper'

describe Category do
  it 'has a valid factory' do
    expect(build(:category)).to be_valid
  end

  it 'is valid with a name' do
    expect(build(:category)).to be_valid
  end

  it 'is invalid without a name' do
    expect(build(:category, name: nil)).not_to be_valid
  end
  
  it 'is invalid with a duplicate name' do
    category = create(:category, name: 'dessert')
    expect(build(:category, name: 'dessert')).not_to be_valid
  end

  it "can't be destroyed while food is using it" do
    category = create(:category)
    food = create(:food, category_id: category.id)

    expect { category.destroy }.not_to change(Category, :count)
  end
end