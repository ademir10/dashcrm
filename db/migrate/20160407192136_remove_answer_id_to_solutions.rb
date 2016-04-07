class RemoveAnswerIdToSolutions < ActiveRecord::Migration
  def change
    remove_column :solutions, :answer_id
  end
end
