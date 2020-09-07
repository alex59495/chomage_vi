class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents do |t|
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :work
      t.date :start_date
      t.datetime :end_date
      t.date :old_start_date
      t.date :old_end_date
      t.string :old_work
      t.string :old_company
      t.string :work_type

      t.timestamps
    end
  end
end
