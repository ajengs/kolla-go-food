class Voucher < ApplicationRecord
  enum unit: {
    "Percent" => "percent",
    "Rupiah" => "rupiah"
  }
  validates :code, :amount, :valid_from, :valid_through, :unit, :max_amount, presence: true
  validates :code, uniqueness: true
  validates :amount, :max_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :unit, inclusion: units.keys
  # validate :valid_through_cannot_be_less_than_valid_from

  before_save :capitalize_code

  private
    def capitalize_code
      code.upcase!
    end
    
    # def valid_through_cannot_be_less_than_valid_from
    #   if valid_through < valid_from
    #     errors.add(:valid_through, "can't be less than valid from")
    #   end
    # end
end
