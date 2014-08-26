class RenamePreGroupColumn < ActiveRecord::Migration
  def change
	  rename_column :pre_reqs, :group, :pre_req_group_id
  end
end
