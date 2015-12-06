class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :from_id
      t.integer :to_id
      t.string :text, null: false

      t.timestamps null: false
    end

    add_foreign_key :messages, :users, column: :from_id
    add_foreign_key :messages, :users, column: :to_id
  end
end
