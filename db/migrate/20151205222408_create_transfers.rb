class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :from_user_id, index: true, foreign_key: true
      t.integer :to_user_id, index: true, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.references :discount, index: true, foreign_key: true
      t.integer :related_merchant_id, index: true, foreign_key: true
      t.references :currency, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_foreign_key :transfers, :users, column: :from_user_id
    add_foreign_key :transfers, :users, column: :to_user_id
  end
end
