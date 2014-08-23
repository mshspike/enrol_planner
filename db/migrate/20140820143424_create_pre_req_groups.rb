class CreatePreReqGroups < ActiveRecord::Migration
  def change
    create_table :pre_req_groups do |t|
      t.references :unit, index: true

      t.timestamps
    end
  end
end
