class CreateInfoPreliminaires < ActiveRecord::Migration[6.0]
  def change
    create_table :info_preliminaires do |t|
      t.boolean :travail
      t.boolean :chomage

      t.timestamps
    end
  end
end
