class AddCategorynameToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :category_name, :string
  end
end
