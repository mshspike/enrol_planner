class ChangeStreamcodeFormatInStreamsTable < ActiveRecord::Migration
  def up
    change_column :streams, :streamCode, :string
  end

  def down
      change_column :streams, :streamCode, :integer
  end
end
