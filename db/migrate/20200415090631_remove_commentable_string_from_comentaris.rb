class RemoveCommentableStringFromComentaris < ActiveRecord::Migration[6.0]
  def change

    remove_column :comentaris, :commentable_type, :string
  end
end
