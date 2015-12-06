class RemoveSsnConstraintFromUser < ActiveRecord::Migration
  def change
    change_column_null :users, :ssn, true
  end
end
