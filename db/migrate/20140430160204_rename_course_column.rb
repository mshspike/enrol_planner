class RenameCourseColumn < ActiveRecord::Migration
  def change
	rename_column :streams, :courseName, :streamName
	rename_column :units, :Course_id, :Stream_id
  end
end
