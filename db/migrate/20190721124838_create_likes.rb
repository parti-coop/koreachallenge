class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.references :likable, null: false, polymorphic: true
      t.references :user, null: false
      t.timestamps null: false
    end
  end
end
