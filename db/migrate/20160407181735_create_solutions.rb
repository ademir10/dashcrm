class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.integer :answer_id
      t.string :description

      t.timestamps null: false
    end
  end
end
