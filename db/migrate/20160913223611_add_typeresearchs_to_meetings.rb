class AddTyperesearchsToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :type_research, :string
  end
end
