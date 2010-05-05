class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :project_id
      t.string  :name,      :null => false
      t.boolean :completed, :default => false, :null => false
      t.boolean :checked,   :default => false, :null => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :tasks
  end
end
