class AddTypeClientToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :type_client, :string
  end
end
