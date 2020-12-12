class AddSartRecalcToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :start_recalc, :date
  end
end
