class AddPrivateOfComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :private, :boolean, default: 'false' 
  end
end
