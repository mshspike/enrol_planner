class CreateUnitPreReqs < ActiveRecord::Migration
  def change
    create_table :unit_pre_reqs do |t|
      t.integer :uCode
      t.integer :pCode
      t.string :option

      t.timestamps
    end
  end
end
