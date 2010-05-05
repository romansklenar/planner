class AddTaskDateAttributes < ActiveRecord::Migration
  def self.up
    add_column :tasks, :completed_at, :datetime, :null => true
    add_column :tasks, :checked_at, :datetime, :null => true
    add_column :tasks, :due_to, :date, :null => true
    add_column :tasks, :scheduled_to, :date, :null => true
  end

  def self.down
    remove_column :tasks, :completed_at
    remove_column :tasks, :checked_at
    remove_column :tasks, :due_to
    remove_column :tasks, :scheduled_to
  end
end
