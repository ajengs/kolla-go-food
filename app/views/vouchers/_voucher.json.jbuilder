json.extract! voucher, :id, :code, :amount, :unit, :valid_from, :valid_through, :max_amount, :created_at, :updated_at
json.url voucher_url(voucher, format: :json)
