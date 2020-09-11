class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents do |t|
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :work
      t.string :work_type
      t.date :start_date
      t.date :end_date
      t.date :old_start_date
      t.date :old_end_date
      t.string :old_work
      t.string :old_company
      t.date :start_unemployment_at
      t.references :info, null: false, foreign_key: true

      t.timestamps
    end
  end
end
