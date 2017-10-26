require 'rails_helper'

describe Buyer do
  it 'is valid with an email, name, phone, and address' do
    expect(build(:buyer)).to be_valid
  end

  it 'is invalid without an emai' do
    buyer = build(:buyer, email: nil)
    buyer.valid?
    expect(buyer.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a name' do
    buyer = build(:buyer, name: nil)
    buyer.valid?
    expect(buyer.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without a phone' do
    buyer = build(:buyer, phone: nil)
    buyer.valid?
    expect(buyer.errors[:phone]).to include("can't be blank")
  end

  it 'is invalid without an address' do
    buyer = build(:buyer, address: nil)
    buyer.valid?
    expect(buyer.errors[:address]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email' do
    buyer1 = create(:buyer, email: 'harry@gryffindor.com')
    buyer2 = build(:buyer, email: 'harry@gryffindor.com')
    buyer2.valid?
    expect(buyer2.errors[:email]).to include('has already been taken')
  end

  it 'is invalid with an email other than given format' do
    buyer = build(:buyer, email: 'harry@gryffindorcom')
    buyer.valid?
    expect(buyer.errors[:email]).to include('format not valid')
  end

  it 'is invalid with phone number not numeric' do
    buyer = build(:buyer, phone: '09-4748')
    buyer.valid?
    expect(buyer.errors[:phone]).to include('is not a number')
  end

  it 'is invalid with phone number length > 12' do
    buyer = build(:buyer, phone: '0998975757893')
    buyer.valid?
    expect(buyer.errors[:phone]).to include('is too long (maximum is 12 characters)')
  end
end
