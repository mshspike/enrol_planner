class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.integer :unitCode
      t.string :unitName
      t.boolean :semOne
      t.boolean :semTwo
      t.integer :preUnit
      t.integer :creditPoints

      t.timestamps
    end
  end
end
