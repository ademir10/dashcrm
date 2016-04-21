class AddRangeAndQntToCategories < ActiveRecord::Migration
def change
    add_column :categories, :r1, :decimal
    add_column :categories, :r2, :decimal
    add_column :categories, :r3, :decimal
    add_column :categories, :r4, :decimal
    add_column :categories, :r5, :decimal
    add_column :categories, :r6, :decimal
    add_column :categories, :qnt_question, :integer
  end
end
