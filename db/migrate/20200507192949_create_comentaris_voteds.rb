class CreateComentarisVoteds < ActiveRecord::Migration[6.0]
  def change
    create_table :comentaris_voteds do |t|
      t.integer :uid
      t.integer :comentari

      t.timestamps
    end
  end
end
