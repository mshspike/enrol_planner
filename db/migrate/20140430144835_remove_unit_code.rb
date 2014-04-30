class RemoveUnitCode < ActiveRecord::Migration
  def change
	remove_column :units, :unitcode, :integer
	remove_column :courses, :coursecode, :integer
  end
end
