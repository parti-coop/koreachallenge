class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :poll, null: false
      t.references :user, null: false
      t.timestamps null: false
    end
  end
end
