class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :persistence_token
      t.string :crypted_password
      t.string :password_salt
      t.timestamps
    end

    # default admin user
    admin = User.new
    admin.username = "admin"
    admin.email = "admin@example.com"
    admin.password = admin.password_confirmation = "demo"
    admin.save

  end
  
  def self.down
    drop_table :users
  end
end
