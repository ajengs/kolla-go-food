require 'rails_helper'

describe Tag do
  it 'has a valid factory' do
    expect(build(:tag)).to be_valid
  end

  it 'is valid with name' do
    expect(build(:tag)).to be_valid
  end

  it 'is valid without a name' do
    tag = build(:tag, name: nil)
    tag.valid?
    expect(tag.errors[:name]).to include("can't be blank")
  end

  it 'is invalid with duplicate name' do
    tag1 = create(:tag, name: 'sweet')
    tag2 = build(:tag, name:'sweet')
    tag2.valid?
    expect(tag2.errors[:name]).to include('has already been taken')
  end

  it 'is invalid with case insesitive duplicate name' do
    tag1 = create(:tag, name: 'sweet')
    tag2 = build(:tag, name:'SWEET')
    tag2.valid?
    expect(tag2.errors[:name]).to include('has already been taken')
  end

  it 'saves name in lower case' do
    tag = create(:tag, name: 'SWEET')
    expect(tag.name).to eq('sweet')
  end
end
