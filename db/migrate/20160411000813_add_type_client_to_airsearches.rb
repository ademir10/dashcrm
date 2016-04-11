class AddTypeClientToAirsearches < ActiveRecord::Migration
  def change
    add_column :airsearches, :type_client, :string
  end
end
