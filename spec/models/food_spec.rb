require 'rails_helper'

describe Food do
  describe 'Check field validity' do
    before :each do
      @food = Food.new(
        name: 'Sate Ayam',
        description: 'Sate yang dibuat dari daging ayam',
        price: 30000.0
      )
    end

    context 'with valid name and description' do
      it 'is valid with a name and description' do
        expect(@food).to be_valid
      end
    end

    context 'without valid name' do
      it 'is invalid without a name' do
        @food.name = nil
        @food.valid?
        expect(@food.errors[:name]).to include("can't be blank")
      end
    end

    context 'without valid description' do
      it 'is invalid without a description' do
        @food.description = nil
        @food.valid?
        expect(@food.errors[:description]).to include("can't be blank")
      end
    end

    context 'without valid price' do
      it 'is a valid with numeric price' do
        @food.price = '5ooo'
        @food.valid?
        expect(@food.errors[:price]).to include("is not a number")
      end
    end

    context 'with price >= 0.01' do
      it 'is valid with price >= 0.01' do
        @food.price = 0.01
        @food.valid?
        expect(@food).to be_valid
      end
    end
    
    context 'with price < 0.01' do
      it 'is invalid with a price < 0.01' do
        @food.price = -10.0
        @food.valid?
        expect(@food.errors[:price]).to include("must be greater than or equal to 0.01")
      end
    end
      
    context "with image ends with something other than '.gif, '.jpg', '.png'" do
      it "is invalid with image ends with other than '.gif, '.jpg', '.png'" do
        @food.image_url = 'text.csv'
        @food.valid?
        expect(@food.errors[:image_url]).to include("must be a URL for GIF, JPG or PNG image")
      end
    end
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

  describe 'Filter name by letter' do
    before :each do
      @food1 = Food.create(
        name: 'Nasi Uduk',
        description: 'Betawi style steamed rice cooked in coconut milk',
        price: 10000.0
      )

      @food2 = Food.create(
        name: 'Kerak Telor',
        description: 'Betawi traditional spicy omelette',
        price: 8000.0
      )

      @food3 = Food.create(
        name: 'Nasi Semur',
        description: 'Based on dongfruit',
        price: 9000.0
      )
    end

    context 'with matching letters' do
      it 'returns a sorted array of results that match' do    
        expect(Food.by_letter('N')).to eq([@food3, @food1])
      end
    end

    context 'with non-matching letters' do
      it 'omits results that do not match' do
        expect(Food.by_letter('N')).not_to include(@food2)
      end
    end
  end
end