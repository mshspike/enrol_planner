class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :unitName
      t.boolean :semOne
      t.boolean :semTwo
      t.references :Course, index: true

      t.timestamps
    end
  end
end
