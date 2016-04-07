class RemoveReferenceToSolution < ActiveRecord::Migration
  def change
    remove_reference :solutions, :answer, index: true
  end
end
