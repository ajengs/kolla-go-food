class Buyer < ApplicationRecord
  # email format, phone number format : angka <= 12 chars
  validates :email, :name, :phone, :address, presence: true
  validates :email, uniqueness: true, format: {
    with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: 'Email not valid'
  }
  validates :phone, length: { is: 12 }, numericality: true
  # format: {
  #   with: /\A[+-]?\d+\z/,
  #   message: 'Phone number not valid'
  # }
end
