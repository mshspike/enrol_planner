class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :staffID
      t.string :password

      t.timestamps
    end
  end
end
