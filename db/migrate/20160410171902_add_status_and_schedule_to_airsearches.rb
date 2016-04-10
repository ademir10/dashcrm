class AddStatusAndScheduleToAirsearches < ActiveRecord::Migration
  def change
    add_column :airsearches, :status, :string
    add_column :airsearches, :obs, :string
    add_column :airsearches, :schedule, :date
  end
end
