require 'rails_helper'

describe User do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'is valid with a username' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without a username' do
    user = build(:user, username: nil)
    user.valid?
    expect(user.errors[:username]).to include("can't be blank")
  end

  it 'is invalid with a duplicate username' do
    user1 = create(:user, username: 'user')
    user = build(:user, username: 'user')
    user.valid?
    expect(user.errors[:username]).to include("has already been taken")
  end

  context 'on a new user' do
    it 'is invalid without a password' do
      user = build(:user, password: nil, password_confirmation: nil)
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'is invalid with less than 8 characters password' do
      user = build(:user, password: 'short', password_confirmation: 'short')
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
    end

    it 'is invalid with a confirmation mismatch' do
      user = build(:user, password: 'longpassword', password_confirmation: 'longpasssssssss')
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  context 'on an existing user' do
    before :each do
      @user = create(:user)
    end

    it 'is valid with no changes' do
      expect(@user.valid?).to eq(true)
    end

    it 'is invalid with an empty password' do
      @user.password_digest = ''
      # @user.password_confirmation = ''
      @user.valid?
      expect(@user.errors[:password]).to include("can't be blank")
    end

    it 'is valid with a new valid password' do
      @user.password = 'newlongpassword'
      @user.password_confirmation = 'newlongpassword'
      expect(@user.valid?).to eq(true)
    end
  end

  describe "relations" do
    it { should have_many(:roles).through(:assignments) }
    it { should have_many(:orders) }
  end

  describe 'adding gopay amount' do
    it "save default go pay credit when user created" do
      user = create(:user)
      expect(user.gopay).to eq(200000) 
    end

    it 'is invalid with non numeric gopay' do
      user = create(:user)
      user.gopay = '1ooo'
      user.valid?
      expect(user.errors[:gopay]).to include('is not a number')
    end

    it 'is invalid with gopay amount entry < 0' do
      user = create(:user)
      user.gopay = -100
      user.valid?
      expect(user.errors[:gopay]).to include('must be greater than 0')
    end

    it 'updates gopay amount with valid topup gopay' do
      user = create(:user, gopay: 200000)
      topup_gopay = 100000
      user.topup(topup_gopay)
      expect(user.gopay).to eq(300000)
    end

    it 'is invalid with non numeric topup_gopay ' do
      user = create(:user)
      topup_gopay = "1ooo"
      user.topup(topup_gopay)
      expect(user.errors[:gopay]).to include("is not a number")
    end

    it 'is invalid with topup_gopay amount entry < 0' do
      user = create(:user)
      topup_gopay = -20000
      user.topup(topup_gopay)
      expect(user.errors[:gopay]).to include('must be greater than 0')
    end
  end
end
