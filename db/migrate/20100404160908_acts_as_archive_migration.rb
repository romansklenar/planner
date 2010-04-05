class ActsAsArchiveMigration < ActiveRecord::Migration
  def self.up
    ActsAsArchive.update Project
  end

  def self.down
  end
end
