require 'rails_helper'

describe Assignment do
  it 'has a valid factory' do
    expect(build(:assignment)).to be_valid
  end

  it 'is valid with user id and role id' do
    expect(build(:assignment)).to be_valid
  end

  # it 'is invalid without user id' do
  #   assignment = build(:assignment, user: nil)
  #   assignment.valid?
  #   expect(assignment.errors[:user_id]).to include("can't be blank")
  # end

  # it 'is invalid without role id' do
  #   assignment = build(:assignment, role: nil)
  #   assignment.valid?
  #   expect(assignment.errors[:role_id]).to include("can't be blank")
  # end

  describe 'relations' do
    it { should belong_to(:user) }
    it { should belong_to(:role) }
  end

  it 'should save user id and role id' do
    user = create(:user)
    role = create(:role)
    user.roles = [role]
    expect(user.roles).to match_array([role])
  end
end
