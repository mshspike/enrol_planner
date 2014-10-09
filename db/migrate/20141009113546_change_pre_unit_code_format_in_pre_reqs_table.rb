class ChangePreUnitCodeFormatInPreReqsTable < ActiveRecord::Migration
  def up
    change_column :pre_reqs, :preUnit_code, :string
  end

  def down
      change_column :pre_reqs, :preUnit_code, :integer
  end
end
