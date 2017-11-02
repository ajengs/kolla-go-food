json.extract! user, :id, :username, :password, :password_confirmation, :created_at, :updated_at
json_url order_url(user, format: :json)
