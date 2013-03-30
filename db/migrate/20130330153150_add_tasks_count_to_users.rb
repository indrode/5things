class AddTasksCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :tasks_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :tasks_count
  end
end
