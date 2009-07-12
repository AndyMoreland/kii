class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login, :crypted_password, :password_salt, :persistence_token
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
