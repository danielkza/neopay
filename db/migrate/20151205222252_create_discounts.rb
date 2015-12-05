class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.text :description
      t.references :merchant, index: true, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.boolean :is_percentage
      t.string :user_profile
      t.references :currency, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
