class AddTasksCountToTasklists < ActiveRecord::Migration
  def self.up
    add_column :tasklists, :tasks_count, :integer, :default => 0
  end

  def self.down
    remove_column :tasklists, :tasks_count
  end
end
