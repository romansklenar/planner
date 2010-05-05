class CreateWorktypes < ActiveRecord::Migration
  def self.up
    create_table :worktypes do |t|
      t.string :name
      t.float :price_per_hour
      t.timestamps
    end
  end
  
  def self.down
    drop_table :worktypes
  end
end
