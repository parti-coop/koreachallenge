class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user, null: false
      t.references :commentable, null: false, polymorphic: true
      t.text :body
      t.integer :likes_count, default: 0
      t.timestamps null: false
    end
  end
end
