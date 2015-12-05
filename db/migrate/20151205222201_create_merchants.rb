class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :name
      t.string :location
      t.string :field
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
