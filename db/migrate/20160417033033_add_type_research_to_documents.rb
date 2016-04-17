class AddTypeResearchToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :type_research, :string
  end
end
