class RemoveCommentableIdFromComentaris < ActiveRecord::Migration[6.0]
  def change

    remove_column :comentaris, :commentable_id, :integer
  end
end
