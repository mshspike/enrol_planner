class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.string :streamName
      t.integer :streamCode

      t.timestamps
    end
  end
end
