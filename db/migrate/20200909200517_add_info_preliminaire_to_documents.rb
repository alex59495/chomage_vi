class AddInfoPreliminaireToDocuments < ActiveRecord::Migration[6.0]
  def change
    add_reference :documents, :info_preliminaire, null: false, foreign_key: true
  end
end
