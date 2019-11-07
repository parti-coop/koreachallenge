class AddRoundSlugToPolls < ActiveRecord::Migration[5.2]
  def change
    add_column :polls, :round_slug, :string, default: 'pre', null: false
  end
end
