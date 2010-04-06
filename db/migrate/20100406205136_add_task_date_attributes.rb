class AddTaskDateAttributes < ActiveRecord::Migration
  def self.up
    add_column :tasks, :completed_at, :datetime, :null => true
    add_column :tasks, :due_to, :date, :null => true
    add_column :tasks, :scheduled_to, :date, :null => true
    rename_column :tasks, :complete, :completed
  end

  def self.down
    remove_column :tasks, :completed_at
    remove_column :tasks, :due_to
    remove_column :tasks, :scheduled_to
    rename_column :tasks, :completed, :complete
  end
end
