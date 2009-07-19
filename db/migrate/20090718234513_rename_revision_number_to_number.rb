class RenameRevisionNumberToNumber < ActiveRecord::Migration
  def self.up
    rename_column :revisions, :revision_number, :number
  end

  def self.down
  end
end
