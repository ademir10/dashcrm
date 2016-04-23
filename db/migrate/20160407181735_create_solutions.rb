class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.references :answer, index: true, foreign_key: true
      t.string :description
      t.timestamps null: false
    end
  end
end
