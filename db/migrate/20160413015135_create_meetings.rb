class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :name
      t.string :cellphone
      t.datetime :start_time
      t.integer :clerk_id
      t.string :research_path
      t.integer :research_id

      t.timestamps null: false
    end
  end
end
