class Buyer < ApplicationRecord
  # email format, phone number format : angka <= 12 chars
  validates :email, :name, :phone, :address, presence: true
  validates :email, uniqueness: true, format: {
    with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: 'format not valid'
  }
  validates :phone, length: { maximum: 12 }, numericality: true
end
