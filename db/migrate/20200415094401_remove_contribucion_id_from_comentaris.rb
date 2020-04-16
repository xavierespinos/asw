class RemoveContribucionIdFromComentaris < ActiveRecord::Migration[6.0]
  def change

    remove_column :comentaris, :comtribucion_id, :integer
  end
end
