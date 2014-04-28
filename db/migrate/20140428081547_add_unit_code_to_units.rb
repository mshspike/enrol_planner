class AddUnitCodeToUnits < ActiveRecord::Migration
  def change
    add_column :units, :unitCode, :integer
  end
end
