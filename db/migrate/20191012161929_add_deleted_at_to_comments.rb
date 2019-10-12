class AddDeletedAtToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :deleted_at, :datetime
  end
end
