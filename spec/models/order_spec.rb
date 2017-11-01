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
end
