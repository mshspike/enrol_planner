class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      # should we add "unitCode" field in here?
      # the "id" field pre-defined in Rails is auto-assigned
      t.string :unitName
      t.boolean :semOne
      t.boolean :semTwo
      t.references :Course, index: true

      t.timestamps
    end
  end
end
