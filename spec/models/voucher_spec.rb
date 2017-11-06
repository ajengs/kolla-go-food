require 'rails_helper'

describe Voucher do
  it 'has a valid factory' do
    expect(build(:voucher)).to be_valid
  end

  it 'is valid with complete attributes' do
    expect(build(:voucher)).to be_valid
  end

  it 'is invalid without a code' do
    voucher = build(:voucher, code: nil)
    voucher.valid?
    expect(voucher.errors[:code]).to include("can't be blank")
  end

  it 'is saved in all-caps code' do
    voucher = create(:voucher, code: 'code')
    expect(voucher.code).to eq(voucher.code.upcase)
  end

  it 'is invalid with duplicate code' do
    voucher = create(:voucher, code: 'DISC5K')
    voucher2 = build(:voucher, code: 'DISC5K')
    voucher2.valid?
    expect(voucher2.errors[:code]).to include("has already been taken")
  end

  it 'is invalid without amount' do
    voucher = build(:voucher, amount: nil)
    voucher.valid?
    expect(voucher.errors[:amount]).to include("can't be blank")
  end

  it 'is invalid with non-numeric amount' do
    voucher = build(:voucher, amount: '1ooo')
    voucher.valid?
    expect(voucher.errors[:amount]).to include("is not a number")
  end

  it 'is invalid with negative amount' do
    voucher = build(:voucher, amount: -100)
    voucher.valid?
    expect(voucher.errors[:amount]).to include("must be greater than or equal to 0")
  end

  it 'is invalid without unit' do
    voucher = build(:voucher, unit: nil)
    voucher.valid?
    expect(voucher.errors[:unit]).to include("can't be blank")
  end

  it 'is invalid with unit other than percent or rupiah' do
    expect{ build(:voucher, unit: 'dollar') }.to raise_error(ArgumentError)
  end

  it 'is invalid without max_amount' do
    voucher = build(:voucher, max_amount: nil)
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("can't be blank")
  end

  it 'is invalid with non-numeric max_amount' do
    voucher = build(:voucher, max_amount: 'dollar')
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("is not a number")
  end

  it 'is invalid with negative max_amount' do
    voucher = build(:voucher, max_amount: -100)
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("must be greater than or equal to 0")
  end

  it 'is invalid without valid_from' do
    voucher = build(:voucher, valid_from: nil)
    voucher.valid?
    expect(voucher.errors[:valid_from]).to include("can't be blank")
  end

  it 'is invalid without valid_through' do
    voucher = build(:voucher, valid_through: nil)
    voucher.valid?
    expect(voucher.errors[:valid_through]).to include("can't be blank")
  end

  # it 'is invalid if valid_from is not date' do
  #   voucher = build(:voucher, valid_from: '12/13/2011')
  #   voucher.valid?
  #   expect(voucher.errors[:valid_from]).to include("")
  # end

  # it 'is invalid if valid_through is not date' do
  # end

  # it 'is invalid if valid_from > valid_through' do
  #   voucher = build(:voucher, valid_from: Time.now, valid_through: (Time.now - 86400))
  #   voucher.valid?
  #   expect(voucher.errors[:valid_through]).to include("can't be less than valid from")
  # end

  it 'returns discount amount in rupiah' do
    voucher = create(:voucher, amount: 15, unit: 'percent', max_amount: 10000)
    expect(voucher.discount(20000)).to eq(3000)
  end

  describe 'calculates discount' do
    it 'returns the amount of discount' do
      voucher = create(:voucher, amount: 20000, unit: 'rupiah', max_amount: 30000)
      expect(voucher.discount(100000)).to eq(20000)
    end

    it 'returns max amount of discount if discount > max_amount' do
      voucher = create(:voucher, amount: 50, unit: 'percent', max_amount: 30000)
      expect(voucher.discount(100000)).to eq(30000)
    end
  end
end
