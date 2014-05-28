class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.integer :unitCode
      t.string :unitName
      t.integer :preUnit
      t.integer :creditPoints
      t.integer :semAvailable

      t.timestamps
    end
  end
end
