class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :projects
  end
end
