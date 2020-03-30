class AddPointsToContribucion < ActiveRecord::Migration[6.0]
  def change
    add_column :contribucions, :points, :Int, default: 0
  end
end
