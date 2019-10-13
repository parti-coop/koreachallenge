class AddChildrenToComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :parent, null: :true
  end
end
