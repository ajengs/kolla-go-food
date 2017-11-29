class Voucher < ApplicationRecord
  enum unit: {
    "Percent" => "percent",
    "Rupiah" => "rupiah"
  }

  has_many :orders
  validates :code, :amount, :valid_from, :valid_through, :unit, :max_amount, presence: true
  validates :code, uniqueness: { case_sensitive: false }
  validates :amount, :max_amount, numericality: { greater_than: 0 }
  validates :unit, inclusion: units.keys
  validate :valid_through_must_be_greater_than_or_equal_to_valid_from
  # validates_each :valid_through do |record, attr, value|
  #   if !value.nil? && !record.valid_from.nil?
  #     record.errors.add(attr, "must be greater than or equal to valid from") if value < record.valid_from
  #   end
  # end
  validate :max_amount_must_be_greater_than_or_equal_to_amount_if_rupiah
  # validates_with VoucherAmountValidator

  before_save :capitalize_code
  before_destroy :ensure_not_referenced_by_any_order

  def discount(price)
    disc = 0
    if unit == 'Rupiah'
      disc = amount
    elsif unit == 'Percent'
      disc = (price * amount / 100).round
    end
    disc > max_amount ? max_amount : disc
  end

  private
    def capitalize_code
      code.upcase!
    end

    def valid_through_must_be_greater_than_or_equal_to_valid_from
      if valid_through.present? && valid_from.present? && valid_from > valid_through
        errors.add(:valid_through, "must be greater than or equal to valid from")
      end
    end

    def max_amount_must_be_greater_than_or_equal_to_amount_if_rupiah
      if unit.present? && unit == 'Rupiah' && max_amount < amount
        errors.add(:max_amount, "must be greater than or equal to amount")
      end
    end

    def ensure_not_referenced_by_any_order
      unless orders.empty?
        errors.add(:base, 'Orders present')
        throw :abort
      end
    end
end
