class RenameCourse < ActiveRecord::Migration
  def change
	rename_table :courses, :streams
  end
end
