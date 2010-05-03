class CreateTasklists < ActiveRecord::Migration
  def self.up
    create_table :tasklists do |t|
      t.string :name
      t.string :type
      t.text :description
      t.integer :user_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :tasklists
  end
end
