class CreatePreReqs < ActiveRecord::Migration
  def change
    create_table :pre_reqs do |t|
      t.integer :group                  # Reference ID to group
      t.references :unit, index: true   # Reference ID to unit
      t.integer :preUnit_code           # Reference unit code to pre-requisite

      t.timestamps
    end
  end
end