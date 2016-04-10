class AddCcliToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ccli, :boolean
  end
end
