class User < ApplicationRecord
  require 'bcrypt'
  before_save :encrypt_password, if: :password_changed?
  validates :user_name, presence: true, length: {minimum: 3, maximum: 15}
  validates :password, presence: true, length: {minimum: 8}

  def authenticate(pass)
    BCrypt::Password.new(password) == pass
  end

  private

  def encrypt_password
    self.password = BCrypt::Password.create(password)
  end

end
