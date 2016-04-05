class ChangeColumnNameTypeInAdvice < ActiveRecord::Migration
  def change
    rename_column :advices, :type, :type_advice
  end
end
