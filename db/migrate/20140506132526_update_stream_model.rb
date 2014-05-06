class UpdateStreamModel < ActiveRecord::Migration
  def change
	add_column :streams, :streamCode, :integer
  end
end
