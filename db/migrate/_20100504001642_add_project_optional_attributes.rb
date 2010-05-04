class AddProjectOptionalAttributes < ActiveRecord::Migration
  def self.up
    add_column :projects, :type, :string, :default => 'P', :null => false
    add_column :projects, :description, :text
    add_column :projects, :note, :text
    add_column :projects, :budget_hours, :float
    add_column :projects, :grant_id, :integer
    t.timestamps
  end

  def self.down
    remove_column :projects, :type
    remove_column :projects, :description
    remove_column :projects, :note
    remove_column :projects, :budget_hours
    remove_column :projects, :grant_id
  end
end
