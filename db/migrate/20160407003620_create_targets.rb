class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.references :advice, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
