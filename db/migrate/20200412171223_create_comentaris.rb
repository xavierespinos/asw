class CreateComentaris < ActiveRecord::Migration[6.0]
  def change
    create_table :comentaris do |t|
      t.string :text , null: false
      t.integer :contribucion_id , null: false
      t.integer :comentari_id, null: false, default: 0
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
