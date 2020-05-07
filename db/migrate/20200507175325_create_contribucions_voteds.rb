class CreateContribucionsVoteds < ActiveRecord::Migration[6.0]
  def change
    create_table :contribucions_voteds do |t|
      t.integer :user
      t.integer :contribucion

      t.timestamps
    end
  end
end
