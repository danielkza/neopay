class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :phone
      t.string :data

      t.timestamps null: false
    end
  end
end
