class Restaurant < ApplicationRecord
  has_many :foods
  has_many :reviews, as: :reviewable
  validates :name, :address, presence: true
  validates :name, uniqueness: true
  before_destroy :ensure_not_referenced_by_any_food

  private
    def ensure_not_referenced_by_any_food
      unless foods.empty?
        errors.add(:base, 'Foods present')
        throw :abort
      end
    end  
end
