class Food < ApplicationRecord
  has_many :line_items
  has_and_belongs_to_many :tags
  has_many :reviews, as: :reviewable
  belongs_to :category, optional: true
  belongs_to :restaurant
  
  validates :name, :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :name, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\z}i,
    message: 'must be a URL for GIF, JPG or PNG image'
  }
  before_destroy :ensure_not_referenced_by_any_line_item

  def self.by_letter(letter)
    where("name LIKE ?", "#{letter}%").order(:name)
  end

  def self.by_category(category_id)
    where("category_id = ?", category_id)
  end

  private
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
      end
    end
end
