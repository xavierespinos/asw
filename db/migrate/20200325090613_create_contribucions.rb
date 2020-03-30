class CreateContribucions < ActiveRecord::Migration[6.0]
  def change
    create_table :contribucions do |t|
      t.integer :user_id
      t.text :title
      t.text :url
      t.text :text

      t.timestamps
    end
    add_index :contribucions, [:user_id, :created_at]
  end
end
