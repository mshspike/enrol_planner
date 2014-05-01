class CreateStreamsUnits < ActiveRecord::Migration
  def change
    create_table :streams_units do |t|

      t.timestamps
    end
  end
end
