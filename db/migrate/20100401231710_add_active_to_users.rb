class AddActiveToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :active, :boolean, :default => false, :null => false

    admin = User.find_by_login('admin')
    admin.activate!
    admin.save
  end

  def self.down
    remove_column :users, :active
  end
end
