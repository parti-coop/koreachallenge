class CreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :polls do |t|
      t.string :title, null: false
      t.text :body
      t.string :image
      t.integer :reads_count, default: 0
      t.integer :votes_count, default: 0
      t.integer :comments_count, default: 0
      t.references :user, null: false
      t.timestamps null: false
    end
  end
end
