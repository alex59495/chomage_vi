class DropProfiles < ActiveRecord::Migration[6.0]
  def change
    drop_table :profiles
  end
end
