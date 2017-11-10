class AddTitleDescriptionToReviews < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :title, :string
    add_column :reviews, :description, :text
  end
end
