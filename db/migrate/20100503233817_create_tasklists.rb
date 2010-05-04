class CreateTasklists < ActiveRecord::Migration
  def self.up
    create_table :tasklists do |t|
      t.string :name, :null => false
      t.integer :user_id, :null => false
      t.string :kind, :default => 'P', :null => false
      t.string :state, :default => 'active', :null => false
      t.text :description
      t.text :note
      t.float :budget_hours
      t.integer :grant_id # :null => false
      t.timestamps
    end

    add_index :tasklists, :kind
    add_index :tasklists, :user_id
    add_index :tasklists, :grant_id
  end
  
  def self.down
    drop_table :tasklists
    
    remove_index :tasklists, :kind
    remove_index :tasklists, :user_id
    remove_index :tasklists, :grant_id
  end
end
