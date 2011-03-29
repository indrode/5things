class Task < ActiveRecord::Base
  validates_presence_of :body
  belongs_to :user, :counter_cache => true
  belongs_to :tasklist, :counter_cache => true 
  
  # find all tasks where date is within range yesterday..tomorrow of given day
  def self.find_batch(id, from, to)
    all(:order => 'duedate, ordinal ASC', :conditions => ["duedate IN (?) AND tasklist_id = ?", (from..to), id ])
  end

  # find all incomplete tasks where date is within range yesterday..tomorrow of given day
  def self.find_incomplete_batch(id, from, to)
    all(:order => 'duedate, ordinal ASC', :conditions => ["duedate IN (?) AND tasklist_id = ? AND completed=0", (from..to), id ])
  end
  
  # no use for this yet
  def self.search(search)
    search_condition = "%" + search + "%"
    all(:conditions => ['body LIKE ?', search_condition])
  end

  # finds all past tasks that are not completed
  def self.find_overdue(id)
    all(:order => 'duedate, ordinal ASC', :conditions => ["duedate > (?) AND duedate < (?) AND completed = 0 AND tasklist_id = ?", NEVER, Time.zone.now.to_date, id])
  end

  # find all tasks that have not been assigned to a date
  def self.find_unassigned(id)
    all(:order => 'duedate, ordinal ASC', :conditions => ["duedate IN (?) AND tasklist_id = ?", NEVER, id])
  end

  # find all tasks that are assigned to a date
  def self.find_assigned(id)
    all(:order => 'duedate, ordinal ASC', :conditions => ["duedate > (?) AND tasklist_id = ?", NEVER, id])    
  end
  
  def self.find_upcoming(id)
    all(:order => 'duedate, ordinal ASC', :conditions => ["duedate >= (?) AND tasklist_id = ?", Time.zone.now.to_date, id])    
  end
    
  # find all past dates  
  def self.find_past(id)
    all(:order => 'duedate, ordinal ASC', :conditions => ["duedate > (?) AND duedate < (?) AND tasklist_id = ?", NEVER, Time.zone.now.to_date, id])
  end
    
  # updates all items with their correct sort order and date
  def self.order(ids, newdate)
    if ids
      update_all(
        ['ordinal = FIND_IN_SET(id, ?)', ids.join(',')],
        { :id => ids }
      )
      update_all(
      ['duedate = ?', newdate],
      { :id => ids }   
      )
    end
  end
  
  # set completed status of a task
  def self.checkitem(id, status)
    update(id, :completed => status)
  end
  
  # update task body
  def self.updateBody(id, body)
    update(id, :body => body)
  end
  
end
