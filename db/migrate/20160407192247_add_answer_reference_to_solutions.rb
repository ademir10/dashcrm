class AddAnswerReferenceToSolutions < ActiveRecord::Migration
  def change
    add_reference :solutions, :answer, index: true, foreign_key: true
  end
end
