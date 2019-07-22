class RemoveTeamMemberCountFromIdeas < ActiveRecord::Migration[5.2]
  def change
    remove_column :ideas, :team_member_count
  end
end
