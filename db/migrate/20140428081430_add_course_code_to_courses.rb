class AddCourseCodeToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :courseCode, :integer
  end
end
