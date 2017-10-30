json.extract! drink, :id, :name, :description, :image_url, :price, :category_id, :created_at, :updated_at
json.url drink_url(drink, format: :json)
