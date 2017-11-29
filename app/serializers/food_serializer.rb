class FoodSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price
  belongs_to :category
  belongs_to :restaurant
end
