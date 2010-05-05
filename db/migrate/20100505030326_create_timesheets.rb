class CreateTimesheets < ActiveRecord::Migration
  def self.up
    create_table :timesheets do |t|
      t.integer :task_id, :null => false
      t.integer :user_id, :null => false
      t.datetime :started_at, :null => false
      t.datetime :finished_at, :null => false
      t.text :note
      t.timestamps
    end
  end
  
  def self.down
    drop_table :timesheets
  end
end
