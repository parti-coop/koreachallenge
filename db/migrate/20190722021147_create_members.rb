class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.references :idea
      t.string "name"
      t.string "age"
      t.string "sex"
      t.string "org"
      t.string "address"
      t.string "tel"
      t.string "email"
      t.timestamps null: false
    end

    remove_column :ideas, "planner_name"
    remove_column :ideas, "planner_age"
    remove_column :ideas, "planner_sex"
    remove_column :ideas, "planner_org"
    remove_column :ideas, "planner_address"
    remove_column :ideas, "planner_tel"
    remove_column :ideas, "planner_email"
  end
end
