class Tag < ApplicationRecord
  has_and_belongs_to_many :foods
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  before_save :downcase_name

  private
    def downcase_name
      name.downcase!
    end

    def ensure_not_referenced_by_any_food
      unless foods.empty?
        errors.add(:base, 'Foods present')
        throw :abort
      end
    end
end
