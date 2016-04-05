class CreateResearches < ActiveRecord::Migration
  def change
    create_table :researches do |t|
      t.references :category, index: true, foreign_key: true
      t.string :user
      t.string :client
      t.string :cellphone

      t.timestamps null: false
    end
  end
end
