class ChangeMessageNumToString < ActiveRecord::Migration
  def change
    change_column :messages, :from_num, :string
    change_column :messages, :to_num, :string
  end
end
