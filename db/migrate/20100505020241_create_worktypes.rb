class CreateWorktypes < ActiveRecord::Migration
  def self.up
    create_table :worktypes do |t|
      t.string :name
      t.decimal :price_per_hour, :precision => 8, :scale => 2, :default => 0
      t.timestamps
    end
  end
  
  def self.down
    drop_table :worktypes
  end
end
