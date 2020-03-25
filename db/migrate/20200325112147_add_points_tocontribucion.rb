class AddPointsTocontribucion < ActiveRecord::Migration[6.0]
  def change
    add_column :contribucions, :likes, :integer , default: 0
  end
end
