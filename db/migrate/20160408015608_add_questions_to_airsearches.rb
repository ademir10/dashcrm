class AddQuestionsToAirsearches < ActiveRecord::Migration
  def change
    add_column :airsearches, :q8, :string
    add_column :airsearches, :q9, :string
    add_column :airsearches, :q10, :string
  end
end
