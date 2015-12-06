class ChangeSessionDataToText < ActiveRecord::Migration
  def change
    change_column :sessions, :data, :text
  end
end
