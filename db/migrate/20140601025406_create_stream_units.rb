class CreateStreamUnits < ActiveRecord::Migration
  def change
    create_table :stream_units do |t|
      t.integer :stream_id
      t.integer :unit_id

      t.timestamps
    end
  end
end
