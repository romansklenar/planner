class CreateGrants < ActiveRecord::Migration
  def self.up
    create_table :grants do |t|
      t.string :name
      t.float :budget
      t.timestamps
    end
  end
  
  def self.down
    drop_table :grants
  end
end
