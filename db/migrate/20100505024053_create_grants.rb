class CreateGrants < ActiveRecord::Migration
  def self.up
    create_table :grants do |t|
      t.string :name
      t.decimal :budget, :precision => 8, :scale => 2, :default => 0
      t.timestamps
    end
  end
  
  def self.down
    drop_table :grants
  end
end
