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

  it 'can return total of subtotal price from all line items' do
    order = create(:order)
    food1 = create(:food, price: 5000)
    line_item1 = create(:line_item, food: food1, order: order, quantity: 2)
    food2 = create(:food, price: 10000)
    line_item2 = create(:line_item, food: food2, order: order)

    expect(order.total_price).to eq(20000)
  end

  describe 'calculating discount voucher' do
    before :each do
      @voucher = create(:voucher, amount: 20000, unit: 'rupiah', max_amount: 120000)
      @order = create(:order, voucher: @voucher)
      @food1 = create(:food, price: 50000)
      @line_item1 = create(:line_item, food: @food1, order: @order, quantity: 2)
    end    

    it 'returns the amount of discount' do
      expect(@voucher.discount(@order.total_price)).to eq(20000)
    end

    it 'returns total price after discount' do
      expect(@order.total_after_discount).to eq(80000)
    end

    it 'returns zero if total_price < discount' do
      @voucher.amount = 120000
      expect(@order.total_after_discount).to eq(0)
    end

    it 'does not save order if voucher is not found' do
      expect{ create(:order, voucher_id: 1000) }.not_to change(Order, :count)
    end
  end
end
