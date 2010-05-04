class CreateBugs < ActiveRecord::Migration
  def self.up
    create_table :bugs do |t|
      t.string :name
      t.integer :actual_worker_id
      t.boolean :approved
      t.datetime :approved_at
      t.boolean :closed
      t.boolean :closed_at
      t.text :description
      t.text :note
      t.integer :proposed_worker_id
      t.string :reported_by
      t.integer :task_id
      t.integer :position
      t.string :state
      t.timestamps
    end
  end
  
  def self.down
    drop_table :bugs
  end
end
