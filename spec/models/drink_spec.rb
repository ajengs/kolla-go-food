require 'rails_helper'

describe Drink do
  it 'has a valid factory' do
    expect(build(:drink)).to be_valid
  end

  it 'is valid with a name and description' do
    expect(build(:drink)).to be_valid
  end

  it 'is invalid without a name' do
    drink = build(:drink, name: nil)
    drink.valid?
    expect(drink.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without a description' do
    drink = build(:drink, description: nil)
    drink.valid?
    expect(drink.errors[:description]).to include("can't be blank")
  end

  it 'is valid with numeric price' do
    expect(build(:drink, price: 3000)).to be_valid
  end

  it 'is valid with price >= 0.01' do
    expect(build(:drink, price: 0.01)).to be_valid
  end

  it 'is invalid with price < 0.01' do
    drink = build(:drink, price: -10)
    drink.valid?
    expect(drink.errors[:price]).to include('must be greater than or equal to 0.01')
  end

  describe 'Image validity' do
    it 'is valid with file ends with gif, jpg, or png' do
      expect(build(:drink, image_url: 'orange-juice.jpg')).to be_valid
    end
    
    it 'is invalid with file ends with other than gif, jpg, png' do
      drink = build(:drink, image_url: 'text.csv')
      drink.valid?
      expect(drink.errors[:image_url]).to include('must be a URL for GIF, JPG or PNG image')
    end
  end

  it 'is invalid with a duplicate name' do
    drink1 = create(:drink, name: 'Capuccino')
    drink2 = build(:drink, name: 'Capuccino')
    drink2.valid?
    expect(drink2.errors[:name]).to include('has already been taken')
  end

  describe 'Filter name by letter' do
    before :each do
      @drink1 = create(:drink, name: 'Orange Juice')
      @drink2 = create(:drink, name: 'Mangoo Juice')
      @drink3 = create(:drink, name: 'Melon Juice')
    end

    context 'with a matching letter' do
      it 'returns a sorted array of results that match' do
        expect(Drink.by_letter('M')).to eq([@drink2, @drink3])
      end
    end

    context 'with non-matching letters' do
      it 'omits results that do not match' do
        expect(Drink.by_letter('M')).not_to include(@drink1)
      end
    end
  end

  it 'saves category when category id is filled' do
    category = create(:category)
    expect(build(:drink, category: category)).to be_valid
  end

  describe 'Filter by category' do
    before :each do
      @category = create(:category)
      @drink1 = create(:drink, name: 'Iced tea', category: @category)
      @drink2 = create(:drink, name: 'Thai tea', category: @category)
      @drink3 = create(:drink, name: 'Green tea')
    end

    context 'with a category' do
      it 'returns an array of results in a category' do
        expect(Drink.by_category(@category.id)).to eq([@drink1, @drink2])
      end
    end
  end
end