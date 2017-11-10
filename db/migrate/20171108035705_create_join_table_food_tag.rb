class CreateJoinTableFoodTag < ActiveRecord::Migration[5.1]
  def change
    create_join_table :foods, :tags do |t|
      t.index [:food_id, :tag_id]
      # t.index [:tag_id, :food_id]
    end
  end
end
