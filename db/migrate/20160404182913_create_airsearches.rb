class CreateAirsearches < ActiveRecord::Migration
  def change
    create_table :airsearches do |t|
      t.string :client
      t.string :phone
      t.integer :q1
      t.integer :q2
      t.integer :q3

      t.timestamps null: false
    end
  end
end
