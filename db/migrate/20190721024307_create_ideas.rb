class CreateIdeas < ActiveRecord::Migration[5.2]
  def change
    create_table :ideas do |t|
      t.string :category, null: false
      t.string :title, null: false
      t.string :mode
      t.integer :team_member_count
      t.string :team_name
      t.string :planner_name
      t.string :planner_age
      t.string :planner_sex
      t.string :planner_org
      t.string :planner_address
      t.string :planner_tel
      t.string :planner_email
      t.text :motivation
      t.text :summary
      t.text :pt
      t.text :desc
      t.references :user, null: false
      t.timestamps null: false
      t.string :attachment
      t.string :attachment_name
      t.string :attachment_type, null: false
      t.integer :attachment_size, null: false
      t.datetime :submitted_at
    end
  end
end
