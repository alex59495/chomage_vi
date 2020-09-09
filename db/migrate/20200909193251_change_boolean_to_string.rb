class ChangeBooleanToString < ActiveRecord::Migration[6.0]
  def change
    change_column :info_preliminaires, :chomage, :string
    change_column :info_preliminaires, :travail, :string
  end
end
