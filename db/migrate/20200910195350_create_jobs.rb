class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.string :company
      t.string :work
      t.date :start_at
      t.date :end_at
      t.references :info, null: false, foreign_key: true

      t.timestamps
    end
  end
end
