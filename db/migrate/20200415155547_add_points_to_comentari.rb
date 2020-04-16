class AddPointsToComentari < ActiveRecord::Migration[6.0]
  def change
    add_column :comentaris, :points, :Int, default: 0 
  end
end
