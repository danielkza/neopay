class AddConversationStateToUser < ActiveRecord::Migration
  def change
    add_column :users, :conversation_state, :integer, default: 0
  end
end
