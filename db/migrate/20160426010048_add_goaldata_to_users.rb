class AddGoaldataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :goal, :decimal
    add_column :users, :qnt_research, :integer
    add_column :users, :total_sale, :decimal
    add_column :users, :current_percent, :decimal
  end
end
