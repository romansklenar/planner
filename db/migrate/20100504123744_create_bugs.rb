class CreateBugs < ActiveRecord::Migration
  def self.up
    create_table :bugs do |t|
      t.string :name, :null => false
      t.integer :actual_user_id
      t.boolean :approved, :default => false, :null => false
      t.datetime :approved_at
      t.boolean :closed,   :default => false, :null => false
      t.boolean :closed_at
      t.text :description, :null => false
      t.text :note
      t.integer :proposed_user_id
      t.string :reported_by, :null => false
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
