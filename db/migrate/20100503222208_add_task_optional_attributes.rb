class AddTaskOptionalAttributes < ActiveRecord::Migration
  def self.up
    add_column :tasks, :delegated_user_id, :integer
    add_column :tasks, :description, :text
    add_column :tasks, :note, :text
    add_column :tasks, :tasklist_id, :integer
    add_column :tasks, :worktype_id, :integer

    add_index :tasks, :tasklist_id
    add_index :tasks, :project_id
    add_index :tasks, :position
  end

  def self.down
    remove_column :tasks, :delegated_user_id
    remove_column :tasks, :description
    remove_column :tasks, :note
    remove_column :tasks, :tasklist_id
    remove_column :tasks, :worktype_id

    remove_index :tasks, :tasklist_id
    remove_index :tasks, :project_id
    remove_index :tasks, :position
  end
end
