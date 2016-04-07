class AddAnswerToSolution < ActiveRecord::Migration
  def change
    add_column :solutions, :answer, :string
  end
end
