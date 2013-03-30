class AddTasklistIdToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :tasklist_id, :integer
  end

  def self.down
    remove_column :tasks, :tasklist_id
  end
end
