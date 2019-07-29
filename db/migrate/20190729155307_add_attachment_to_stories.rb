class AddAttachmentToStories < ActiveRecord::Migration[5.2]
  def change
    (1..10).each do |i|
      add_column :stories, "attachment#{i}", :string
      add_column :stories, "attachment#{i}_name", :string
      add_column :stories, "attachment#{i}_type", :string
      add_column :stories, "attachment#{i}_size", :integer
    end
  end
end
