class CreateStreamUnits < ActiveRecord::Migration
  def change
    create_table :stream_units do |t|
      t.references :stream, index: true
      t.references :unit, index: true

      t.timestamps
    end
  end
end
