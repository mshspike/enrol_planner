class AddReferences < ActiveRecord::Migration
  def change
	#change_table :Requires do |t|
	#	t.references :Unit
	#change_table :Requires do |t|
	#	t.references :preUnit
	#change_table :streams_units do |t|
	#	t.references :Stream
	#change_table :streams_units do |t|
	#	t.references :Unit
	remove_column :units, :Stream_id, :integer
  end
  end
  

