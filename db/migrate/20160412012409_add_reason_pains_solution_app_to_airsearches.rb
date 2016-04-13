class AddReasonPainsSolutionAppToAirsearches < ActiveRecord::Migration
  def change
    add_column :airsearches, :reason, :string
    add_column :airsearches, :pains, :string
    add_column :airsearches, :solution_applied, :string
    add_column :airsearches, :cotation_value, :decimal
    add_column :airsearches, :finished, :string
  end
end
