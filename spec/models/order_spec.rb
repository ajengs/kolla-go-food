require 'rails_helper'

describe Order do
  it 'has a valid factory' do
    expect(build(:order)).to be_valid
  end

  it 'is valid with a name, address, email, and payment_type' do
    expect(build(:order)).to be_valid
  end

  it 'is invalid without a name' do
    order = build(:order, name: nil)
    order.valid?
    expect(order.errors[:name]).to include("can't be blank")
  end

  it 'is ivalid without an address' do
    order = build(:order, address: nil)
    order.valid?
    expect(order.errors[:address]).to include("can't be blank")
  end

  it 'is invalid without an email' do
    order = build(:order, email: nil)
    order.valid?
    expect(order.errors[:email]).to include("can't be blank")
  end

  it 'is invalid with email not in valid email format' do
    order = build(:order, email: 'ajeng.s')
    order.valid?
    expect(order.errors[:email]).to include("format is invalid")
  end

  it 'is invalid without a payment_type' do
    order = build(:order, payment_type: nil)
    order.valid?
    expect(order.errors[:payment_type]).to include("can't be blank")
  end

  it 'is invalid with wrong payment_type' do
    expect{ build(:order, payment_type: 'Grab Pay') }.to raise_error(ArgumentError)
  end

  describe 'Adding line_items from cart' do
    before :each do
      @cart = create(:cart)
      @line_item = create(:line_item, cart: @cart)
      @order = build(:order)
    end

    it 'adds line_items to order' do    
      expect{
        @order.add_line_items(@cart)
        @order.save
      }.to change(@order.line_items, :count).by(1)
    end

    it 'removes line_items from cart' do
      expect{
        @order.add_line_items(@cart)
        @order.save
      }.to change(@cart.line_items, :count).by(-1)
    end
  end


  it 'saves total of subtotal price from all line items' do

    order = create(:order)
    food1 = create(:food, price: 5000)
    line_item1 = create(:line_item, food: food1, order: order, quantity: 2)
    food2 = create(:food, price: 10000)
    line_item2 = create(:line_item, food: food2, order: order)
    order.total_price = order.total_price_before_discount
    expect(order.total_price).to eq(20000)
  end

  describe 'adding discount voucher' do
    context 'with valid voucher' do
      before :each do
        @voucher = create(:voucher, amount: 20000, unit: 'rupiah', max_amount: 120000)
        @order = create(:order, voucher: @voucher)
        @food1 = create(:food, price: 50000)
        @line_item1 = create(:line_item, food: @food1, order: @order, quantity: 2)
        @order.total_price = @order.set_total_price
      end    

      it 'returns the amount of discount' do
        expect(@order.discount).to eq(20000)
      end

      it 'returns total price after discount' do
        expect(@order.total_price).to eq(80000)
      end

      it 'returns zero if total_price < discount' do
        @voucher.amount = 120000
        expect(@order.set_total_price).to eq(0)
      end
    end
  

    context 'with invalid voucher' do
      it 'is not saved if voucher is not found' do
        order = build(:order, voucher_code: 'nodisc')
        order.valid?
        expect(order.errors[:voucher_id]).to include("not found")
      end

      it 'is not saved if voucher is no valid yet' do
        voucher = create(:voucher, valid_from: 2.days.from_now)
        order = build(:order, voucher: voucher)
        order.valid?
        expect(order.errors[:voucher_id]).to include("no longer valid")
      end

      it 'is not saved if voucher is no longer valid' do
        voucher = create(:voucher, valid_from: 3.days.ago, valid_through: 2.days.ago)
        expect{
          create(:order, voucher: voucher) 
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'relations' do
    it { should belong_to(:user) }
  end

  describe 'paying with gopay' do
    

    context "with sufficient gopay credit" do
      before :each do
        @user = create(:user, gopay: 100000)
        @order = build(:order, user: @user, payment_type: 'Go Pay')
        @food1 = create(:food, price: 50000)
        @line_item1 = create(:line_item, food: @food1, order: @order, quantity: 2)
        @order.total_price = @order.set_total_price
      end 

      it 'is valid with sufficient gopay credit' do
        expect(@order).to be_valid
      end

      it 'substracts user gopay credit with total_price' do
        expect(@order.user.gopay).to eq(0)
      end
    end

    context 'with insufficient gopay credit' do
      before :each do
        @user = create(:user, gopay: 10000)
        @order = build(:order, user: @user, payment_type: 'Go Pay')
        @food1 = create(:food, price: 50000)
        @line_item1 = create(:line_item, food: @food1, order: @order, quantity: 2)
        @order.total_price = @order.set_total_price
      end 

      it 'is invalid with insufficient gopay credit' do
        @order.valid?
        expect(@order.errors[:payment_type]).to include("insufficient gopay credit")
      end

      it 'does not substracts user gopay' do
        expect(@order.user.gopay).not_to eq(0)
      end
    end
  end
end
