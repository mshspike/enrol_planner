class AddDefaultValueToSem < ActiveRecord::Migration
  def change
	change_column :Units, :semOne, :boolean, :default => false
	change_column :Units, :semTwo, :boolean, :default =>false
  end
end
