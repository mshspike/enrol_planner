class RemovePlannedYearFromUnits < ActiveRecord::Migration
  def change
    remove_column :units, :plannedYear, :interger
  end
end
