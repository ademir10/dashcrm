class AddRanaliticToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ranalitic, :boolean
  end
end
