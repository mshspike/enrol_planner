class MotiftyUnitInfo < ActiveRecord::Migration
  def change
  remove_column :units, :semOne, :boolean
  remove_column :units, :semTwo, :boolean
  add_column :units, :semAvailable, :integer
  end
end
