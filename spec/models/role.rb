require 'rails_helper'

describe Role do
  it "has a valid factory" do
    expect(build(:role)).to be_valid
  end

  it "is valid with a name" do
    expect(build(:role)).to be_valid
  end

  it "is invalid without a name" do
    role = build(:role, name: nil)
    role.valid?
    expect(role.errors[:name]).to include("can't be blank")
  end
end