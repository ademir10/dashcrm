class AddPerfilToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ccategory, :boolean
    add_column :users, :cresearch, :boolean
    add_column :users, :cquestion, :boolean
    add_column :users, :cadvice, :boolean
    add_column :users, :cuser, :boolean

  end
end