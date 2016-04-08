class CreateAirsearches < ActiveRecord::Migration
  def change
    create_table :airsearches do |t|
      t.string :user
      t.string :client
      t.string :phone
      t.integer :q1
      t.integer :q2
      t.integer :q3
      t.integer :q4
      t.integer :q5
      t.integer :q6
      t.integer :q7

      t.timestamps null: false
    end
  end
end
