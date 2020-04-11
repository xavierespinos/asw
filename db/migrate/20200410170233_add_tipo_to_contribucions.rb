class AddTipoToContribucions < ActiveRecord::Migration[6.0]
  def change
    add_column :contribucions, :tipo, :string
  end
end
