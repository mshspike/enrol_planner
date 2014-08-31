class ReorderColumns < ActiveRecord::Migration
  def change
    change_column :stream_units, :plannedYear, :integer, after: :unit_id
    change_column :units, :semAvailable, :integer, after: :preUnit

    add_column :stream_units, :plannedSemester, :integer, after: :plannedYear
  end
end
