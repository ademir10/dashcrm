class AddAnswerIdToTargets < ActiveRecord::Migration
  def change
    add_reference :targets, :answer, index: true, foreign_key: true
  end
end
