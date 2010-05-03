class AddTaskOptionalAttributes < ActiveRecord::Migration
  def self.up
    add_column :tasks, :delegated_to, :integer
    add_column :tasks, :description, :string
    add_column :tasks, :note, :string
    add_column :tasks, :tasklist_id, :integer
    add_column :tasks, :worktype_id, :integer
  end

  def self.down
    remove_column :tasks, :delegated_to
    remove_column :tasks, :description
    remove_column :tasks, :note
    remove_column :tasks, :tasklist_id
    remove_column :tasks, :worktype_id
  end
end
