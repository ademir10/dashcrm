class AddClerknameToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :clerk_name, :string
  end
end
