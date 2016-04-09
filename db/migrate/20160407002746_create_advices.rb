class CreateAdvices < ActiveRecord::Migration
  def change
    create_table :advices do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
