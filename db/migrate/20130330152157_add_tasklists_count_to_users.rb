class AddTasklistsCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :tasklists_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :tasklists_count
  end
end
