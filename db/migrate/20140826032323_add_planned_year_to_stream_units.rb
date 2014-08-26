class AddPlannedYearToStreamUnits < ActiveRecord::Migration
  def change
    add_column :stream_units, :plannedYear, :integer
  end
end
