class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.integer :unitCode
      t.string :unitName
      t.boolean :semOne
      t.boolean :semTwo
      t.boolean :preUnit
      t.float :creditPoints

      t.timestamps
    end
  end
end
