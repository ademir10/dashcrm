class AddRangeToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :r1, :integer
    add_column :categories, :r2, :integer
    add_column :categories, :r3, :integer
    add_column :categories, :r4, :integer
    add_column :categories, :r5, :integer
    add_column :categories, :r6, :integer
  end
end
