class UpdateRelationships < ActiveRecord::Migration
  def change
	change_table :units do |t| 
	t.references :Unit
  end
  end
end
