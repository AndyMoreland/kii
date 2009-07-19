class CreateRevisions < ActiveRecord::Migration
  def self.up
    create_table :revisions do |t|
      t.integer :page_id, :null => false
      t.integer :user_id
      t.text :body, :null => false
      t.string :message
      t.integer :revision_number    
      t.string :remote_ip, :referrer
      t.timestamps
    end
    
    add_index :revisions, :page_id
  end

  def self.down
    drop_table :revisions
  end
end
