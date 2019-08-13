class AddReuseToIdeas < ActiveRecord::Migration[5.2]
  def change
    add_column :ideas, :was_reused, :boolean, default: false
    add_column :ideas, :reuse_desc, :text
  end
end
