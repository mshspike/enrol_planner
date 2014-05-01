class RemoveUnitId < ActiveRecord::Migration
  def change
	change_table :units do |t|
	t.remove:Unit_id
  end
end
end