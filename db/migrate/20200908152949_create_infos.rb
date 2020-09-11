class CreateInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :infos do |t|
      t.string :work
      t.string :unemployment
      t.integer :days_unemployment

      t.timestamps
    end
  end
end
