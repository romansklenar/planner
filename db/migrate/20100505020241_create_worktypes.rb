class CreateWorktypes < ActiveRecord::Migration
  def self.up
    create_table :worktypes do |t|
      t.string :name, :null => false
      t.decimal :price_per_hour, :null => false, :precision => 8, :scale => 2, :default => 0
      t.timestamps
    end
  end
  
  def self.down
    drop_table :worktypes
  end
end
