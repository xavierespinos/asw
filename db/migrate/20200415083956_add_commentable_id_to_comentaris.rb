class AddCommentableIdToComentaris < ActiveRecord::Migration[6.0]
  def change
    add_column :comentaris, :commentable_id, :integer
  end
end
