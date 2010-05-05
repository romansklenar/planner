class AddIndexesToKeys < ActiveRecord::Migration
  def self.up
    add_index :tasklists, :name
    add_index :tasklists, :state
    add_index :tasklists, :grant_id

    add_index :tasks, :name
    add_index :tasks, :state
    add_index :tasks, :worktype_id

    add_index :tags, :name, :unique => true
    add_index :grants, :name, :unique => true
    add_index :worktypes, :name, :unique => true

    add_index :bugs, :name
    add_index :bugs, :position
    add_index :bugs, :task_id
    
    add_index :timesheets, :user_id
    add_index :timesheets, :task_id
  end

  def self.down
    remove_index :tasklists, :name
    remove_index :tasklists, :state
    remove_index :tasklists, :grant_id

    remove_index :tasks, :name
    remove_index :tasks, :state
    remove_index :tasks, :worktype_id

    remove_index :tags, :name
    remove_index :grants, :name
    remove_index :worktypes, :name

    remove_index :bugs, :name
    remove_index :bugs, :position
    remove_index :bugs, :task_id

    remove_index :timesheets, :user_id
    remove_index :timesheets, :task_id
  end
end
