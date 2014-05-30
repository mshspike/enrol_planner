class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.string :streanName
      t.string :streamCode

      t.timestamps
    end
  end
end
