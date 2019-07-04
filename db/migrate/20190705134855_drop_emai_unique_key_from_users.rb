class DropEmaiUniqueKeyFromUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :email, true
    remove_index :users, :email
    add_index :users, [:provider, :uid], unique: true
  end
end
