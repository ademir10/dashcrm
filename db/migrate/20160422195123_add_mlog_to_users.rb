class AddMlogToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mlog, :boolean
  end
end
