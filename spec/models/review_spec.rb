require 'rails_helper'

describe Review do
  it 'has a valid factory' do
    expect(build(:review)).to be_valid
  end

  it 'is valid with name, title, description' do
    expect(build(:review)).to be_valid
  end

  it 'is valid without a name' do
    review = build(:review, name: nil)
    review.valid?
    expect(review.errors[:name]).to include("can't be blank")
  end

  it 'is valid without a title' do
    review = build(:review, title: nil)
    review.valid?
    expect(review.errors[:title]).to include("can't be blank")
  end

  it 'is valid without a description' do
    review = build(:review, description: nil)
    review.valid?
    expect(review.errors[:description]).to include("can't be blank")
  end
end
