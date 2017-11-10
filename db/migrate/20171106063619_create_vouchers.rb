class CreateVouchers < ActiveRecord::Migration[5.1]
  def change
    create_table :vouchers do |t|
      t.string :code
      t.decimal :amount
      t.string :unit
      t.date :valid_from
      t.date :valid_through
      t.decimal :max_amount

      t.timestamps
    end
  end
end
