class AddCommentableTypeToComentaris < ActiveRecord::Migration[6.0]
  def change
    add_column :comentaris, :commentable_type, :string
  end
end
