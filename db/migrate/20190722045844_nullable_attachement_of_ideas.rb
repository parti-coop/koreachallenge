class NullableAttachementOfIdeas < ActiveRecord::Migration[5.2]
  def change
    change_column_null :ideas, :attachment_type, true
    change_column_null :ideas, :attachment_size, true
  end
end
