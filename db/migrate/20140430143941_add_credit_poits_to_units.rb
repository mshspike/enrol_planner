class AddCreditPoitsToUnits < ActiveRecord::Migration
  def change
    add_column :units, :creditPoints, :integer
  end
end
