class AddApitokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :apitoken, :string
  end
end
