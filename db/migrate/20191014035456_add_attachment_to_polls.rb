class AddAttachmentToPolls < ActiveRecord::Migration[5.2]
  def change
    (1..10).each do |i|
      add_column :polls, "attachment#{i}", :string
      add_column :polls, "attachment#{i}_name", :string
      add_column :polls, "attachment#{i}_type", :string
      add_column :polls, "attachment#{i}_size", :integer
    end
  end
end
