require 'rails_helper'

RSpec.describe User, type: :model do
  it 'ensures user is successfully created with valid attributes' do
    expect do
      User.create(user_name: 'Flinstones', password: 'yabadabadoo')
    end.to change {User.count}.by(1)
  end

  it 'ensures user password is encrpted before saving' do
    require 'bcrypt' 
    user = User.create(user_name: 'Flinstones', password: 'yabadabadoo')
    expect {BCrypt::Password.new(user.password)}.not_to raise_error
  end

  describe 'invalid attributes' do
    it 'ensures errors are returned if username or password are blank' do
      user = User.new(user_name: nil, password: nil)
      expect(user.valid?).to be false
      expect(user.errors.messages[:user_name]).to include('can\'t be blank', 'is too short (minimum is 3 characters)')
      expect(user.errors.messages[:password]).to include('can\'t be blank', 'is too short (minimum is 8 characters)')
    end
  end
end
