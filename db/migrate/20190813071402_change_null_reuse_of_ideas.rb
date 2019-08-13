class ChangeNullReuseOfIdeas < ActiveRecord::Migration[5.2]
  def change
    change_column_null :ideas, :was_reused, true
    change_column_default :ideas, :was_reused, nil
  end
end
