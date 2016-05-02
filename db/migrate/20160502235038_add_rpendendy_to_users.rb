class AddRpendendyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rpen, :boolean
  end
end
