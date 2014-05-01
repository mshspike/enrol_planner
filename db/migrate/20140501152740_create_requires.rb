class CreateRequires < ActiveRecord::Migration
  def change
    create_table :requires do |t|

      t.timestamps
    end
  end
end
