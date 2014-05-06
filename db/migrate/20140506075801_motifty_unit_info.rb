class MotiftyUnitInfo < ActiveRecord::Migration
  def change
  remove_column :Units, :semOne, :boolean
  remove_column :Units, :semTwo, :boolean
  add_column :Units, :semAvailable, :integer
  end
end
