class ChangeUnitcodeFormatInUnitsTable < ActiveRecord::Migration
  def up
    change_column :units, :unitCode, :string
  end

  def down
    change_column :units, :unitCode, :integer
  end
end
