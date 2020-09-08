class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.string :profile_type
      t.timestamps
    end
  end
end
