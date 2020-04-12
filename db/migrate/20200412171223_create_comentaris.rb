class CreateComentaris < ActiveRecord::Migration[6.0]
  def change
    create_table :comentaris do |t|
      t.string :comentari , null: false
      t.integer :id_contribucio , null: false
      t.integer :id_comentari, null: false, default: 0
      t.integer :id_user, null: false
      t.timestamps
    end
  end
end
