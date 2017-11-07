class VoucherAmountValidator < ActiveModel::Validator
  def validate(record)
    if record.unit.present? && record.unit == 'Rupiah' && record.max_amount < record.amount
      record.errors[:max_amount] << "must be greater than or equal to amount"
    end
  end
end
