class AddMcliRbusinessToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mcli, :boolean
    add_column :users, :rbusiness, :boolean
  end
end
