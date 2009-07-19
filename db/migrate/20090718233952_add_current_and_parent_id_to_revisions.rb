class AddCurrentAndParentIdToRevisions < ActiveRecord::Migration
  def self.up
    add_column :revisions, :current, :boolean, :default => false
    add_column :revisions, :parent_id, :integer
  end

  def self.down
    raise IrreversibleMigration
  end
end
