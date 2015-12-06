class RenameMessagesFromTo < ActiveRecord::Migration
  def up
    remove_foreign_key :messages, column: :from_id
    remove_foreign_key :messages, column: :to_id

    rename_column :messages, :from_id, :from_num
    rename_column :messages, :to_id, :to_num
  end

  def down
    rename_column :messages, :from_num, :from_id
    rename_column :messages, :to_num, :to_id

    add_foreign_key :messages, :users, column: :from_id
    add_foreign_key :messages, :users, column: :to_id
  end
end
