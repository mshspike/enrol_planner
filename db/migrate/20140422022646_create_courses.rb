class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      # should we change the table name to "Stream"?
      # also, should we add "courseCode" field?
      t.string :courseName

      t.timestamps
    end
  end
end
