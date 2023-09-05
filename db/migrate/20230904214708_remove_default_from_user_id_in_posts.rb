class RemoveDefaultFromUserIdInPosts < ActiveRecord::Migration[7.0]
  def up
    change_column_default :posts, :user_id, nil
  end

  def down
    change_column_default :posts, :user_id, 1
  end
end
