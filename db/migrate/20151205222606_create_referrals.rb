class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.integer :old_user_id
      t.integer :new_user_id
      t.references :transfer, index: true, foreign_key: true
      t.references :merchant, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_foreign_key :referrals, :users, column: :old_user_id
    add_foreign_key :referrals, :users, column: :new_user_id
  end
end
