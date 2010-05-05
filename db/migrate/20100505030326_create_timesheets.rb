class CreateTimesheets < ActiveRecord::Migration
  def self.up
    create_table :timesheets do |t|
      t.integer :task_id
      t.integer :user_id
      t.datetime :started_at
      t.datetime :finished_at
      t.text :note
      t.timestamps
    end
  end
  
  def self.down
    drop_table :timesheets
  end
end
