class AddPlannedYearToUnits < ActiveRecord::Migration
  def change
    add_column :units, :plannedYear, :integer
  end
end
