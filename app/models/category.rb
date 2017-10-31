class Category < ApplicationRecord
  has_many :foods
  has_many :drinks
  before_destroy :ensure_not_referenced_by_any_food
  before_destroy :ensure_not_referenced_by_any_drink
  validates :name, presence: true, uniqueness: true

  private
    def ensure_not_referenced_by_any_food
      unless foods.empty?
        errors.add(:base, 'Foods present')
        throw :abort
      end
    end

    def ensure_not_referenced_by_any_drink
      unless drinks.empty?
        errors.add(:base, 'Drinks present')
        throw :abort
      end
    end
end