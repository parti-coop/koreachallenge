class AddUniqUserToIdeas < ActiveRecord::Migration[5.2]
  def change
    remove_index :ideas, name: :index_ideas_on_user_id
    add_index :ideas, [:user_id], unique: true
  end
end
