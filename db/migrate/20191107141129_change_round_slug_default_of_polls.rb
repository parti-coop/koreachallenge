class ChangeRoundSlugDefaultOfPolls < ActiveRecord::Migration[5.2]
  def change
    change_column_default :polls, :round_slug, 'final'
  end
end
