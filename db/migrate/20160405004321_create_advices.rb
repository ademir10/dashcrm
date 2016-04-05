class CreateAdvices < ActiveRecord::Migration
  def change
    create_table :advices do |t|
      t.string :description
      t.string :type

      t.timestamps null: false
    end
  end
end
