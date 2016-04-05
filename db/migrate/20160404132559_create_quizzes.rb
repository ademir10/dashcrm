class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.references :category, index: true, foreign_key: true
      t.string :question
      t.integer :score

      t.timestamps null: false
    end
  end
end
