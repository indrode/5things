class Task < ActiveRecord::Base
  validates_presence_of :body
  belongs_to :user, :counter_cache => true
  belongs_to :tasklist, :counter_cache => true
  
  # named_scope :unassigned, lambda { |day| { :conditions => ["duedate IN (?) AND tasklist_id = ?", NEVER, current_user.current_list ] } }
  
  class << self
    
    # find all tasks where date is within range yesterday..tomorrow of given day
    def find_batch(id, from, to)
      all(:order => 'duedate, ordinal ASC', :conditions => ["duedate IN (?) AND tasklist_id = ?", (from..to), id ])
    end

    # find all incomplete tasks where date is within range yesterday..tomorrow of given day
    def find_incomplete_batch(id, from, to)
      all(:order => 'duedate, ordinal ASC', :conditions => ["duedate IN (?) AND tasklist_id = ? AND completed=0", (from..to), id ])
    end
    
    # no use for this yet
    def search(search)
      search_condition = "%#{search}%"
      all(:conditions => ['body LIKE ?', search_condition])
    end

    # finds all past tasks that are not completed
    def find_overdue(id)
      all(:order => 'duedate, ordinal ASC', :conditions => ["duedate > (?) AND duedate < (?) AND completed = 0 AND tasklist_id = ?", NEVER, Time.zone.now.to_date, id])
    end

    # find all tasks that have not been assigned to a date
    def find_unassigned(id)
      all(:order => 'duedate, ordinal ASC', :conditions => ["duedate IN (?) AND tasklist_id = ?", NEVER, id])
    end

    # find all tasks that are assigned to a date
    def find_assigned(id)
      all(:order => 'duedate, ordinal ASC', :conditions => ["duedate > (?) AND tasklist_id = ?", NEVER, id])    
    end
    
    def find_upcoming(id)
      all(:order => 'duedate, ordinal ASC', :conditions => ["duedate >= (?) AND tasklist_id = ?", Time.zone.now.to_date, id])    
    end
      
    # find all past dates  
    def find_past(id)
      all(:order => 'duedate, ordinal ASC', :conditions => ["duedate > (?) AND duedate < (?) AND tasklist_id = ?", NEVER, Time.zone.now.to_date, id])
    end
      
    # updates all items with their correct sort order and date
    def order(ids, newdate)
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
    def checkitem(id, status)
      update(id, :completed => status)
    end
    
    def update_body(id, body)
      update(id, :body => body)
    end

  end
  
end
