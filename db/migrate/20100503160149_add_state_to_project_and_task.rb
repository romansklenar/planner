class AddStateToProjectAndTask < ActiveRecord::Migration
  def self.up
    add_column :tasks,    :state, :string
    add_column :projects, :state, :string
  end

  def self.down
    remove_column :tasks,    :state
    remove_column :projects, :state
  end
end
