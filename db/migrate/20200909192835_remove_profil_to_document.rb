class RemoveProfilToDocument < ActiveRecord::Migration[6.0]
  def change
    remove_column :documents, :profile_id
  end
end
