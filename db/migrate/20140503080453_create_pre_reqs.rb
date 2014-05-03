class CreatePreReqs < ActiveRecord::Migration
  def change
    create_table :pre_reqs do |t|
      t.references :preUnit, index: true
      t.references :unit, index: true

      t.timestamps
    end
  end
end
