class AddDefaultCurrencyToUser < ActiveRecord::Migration
  def change
    add_column :users, :default_currency_id, :integer

    add_foreign_key :users, :currencies, column: :default_currency_id
  end
end
