class AddInfoToDocuments < ActiveRecord::Migration[6.0]
  def change
    add_reference :documents, :profile, foreign_key: true
    add_column :documents, :chomage_start_date, :date
  end
end
