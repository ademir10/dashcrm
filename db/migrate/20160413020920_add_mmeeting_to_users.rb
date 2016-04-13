class AddMmeetingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mmeeting, :boolean
  end
end
