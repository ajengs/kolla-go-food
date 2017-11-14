class User < ApplicationRecord
  has_secure_password
  has_many :assignments
  has_many :roles, through: :assignments

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 8 }, allow_blank: true
  validates :gopay, numericality: { greater_than: 0 }


  def topup(amount)
    if !(is_numeric? amount)
      errors.add(:gopay, 'is not a number')
      false
    elsif amount.to_i <= 0
      errors.add(:gopay, 'must be greater than 0')
      false
    else
      self.update(gopay: gopay + amount.to_i)
    end
  end

  private
    def is_numeric?(obj) 
       obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end
end
