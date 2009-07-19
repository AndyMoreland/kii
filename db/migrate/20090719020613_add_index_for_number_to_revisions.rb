class AddIndexForNumberToRevisions < ActiveRecord::Migration
  def self.up
    add_index :revisions, :number
  end

  def self.down
    remove_index :revisions, :number
  end
end
