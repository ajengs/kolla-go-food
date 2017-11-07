require 'rails_helper'

describe Voucher do
  it 'has a valid factory' do
    expect(build(:voucher)).to be_valid
  end

  it 'is valid with code, amount, unit, valid_from, valid_through, max_amount' do
    expect(build(:voucher)).to be_valid
  end

  it 'is invalid without a code' do
    voucher = build(:voucher, code: nil)
    voucher.valid?
    expect(voucher.errors[:code]).to include("can't be blank")
  end

  it 'saves code in all capital letters' do
    voucher = create(:voucher, code: 'code')
    expect(voucher.code).to eq('CODE')
  end

  it 'is invalid with duplicate code' do
    voucher = create(:voucher, code: 'DISC5K')
    voucher2 = build(:voucher, code: 'DISC5K')
    voucher2.valid?
    expect(voucher2.errors[:code]).to include("has already been taken")
  end

  it 'is invalid with case insensitive duplicate code' do
    voucher = create(:voucher, code: 'DISC5K')
    voucher2 = build(:voucher, code: 'disc5k')
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

  it 'is invalid with negative or 0 amount' do
    voucher = build(:voucher, amount: -100)
    voucher.valid?
    expect(voucher.errors[:amount]).to include("must be greater than 0")
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

  it 'is invalid with negative or 0 max_amount' do
    voucher = build(:voucher, max_amount: -100)
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("must be greater than 0")
  end

  context 'with unit value rupiah' do
    it 'is invalid with max_amount less than amount' do
      voucher = build(:voucher, unit:'rupiah', amount:10000, max_amount:5000)
      voucher.valid?
      expect(voucher.errors[:max_amount]).to include("must be greater than or equal to amount")
    end
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

  it 'is invalid if valid_from > valid_through' do
    voucher = build(:voucher, valid_from: 1.day.from_now, valid_through: 2.days.ago)
    voucher.valid?
    expect(voucher.errors[:valid_through]).to include("must be greater than valid from")
  end

  describe 'calculates discount' do
    it 'returns the amount of discount' do
      voucher = create(:voucher, amount: 20000, unit: 'rupiah', max_amount: 30000)
      expect(voucher.discount(100000)).to eq(20000)
    end

    it 'returns discount amount in rupiah' do
      voucher = create(:voucher, amount: 15, unit: 'percent', max_amount: 10000)
      expect(voucher.discount(20000)).to eq(3000)
    end

    it 'returns max amount of discount if discount > max_amount' do
      voucher = create(:voucher, amount: 50, unit: 'percent', max_amount: 30000)
      expect(voucher.discount(100000)).to eq(30000)
    end
  end

  it "can't be destroyed wile it has order(s)" do
    voucher = create(:voucher)
    order = create(:order, voucher: voucher)

    expect{ voucher.destroy }.not_to change(Voucher, :count)
  end
end
