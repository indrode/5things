class TasksController < ApplicationController
  before_filter :require_user, :except => [:find_today, :increment_taskcount]  
  layout "general", :except => [:create]
  require 'icalendar'
  require 'fastercsv'
  
  def index
        
    #this adds two seconds
    # sleep 2    
    tasklist_id = current_user.current_list
    
    @today = Time.zone.now.to_date
    @actualday = Time.zone.now.to_date
    unless params[:d].blank?      
      @today = params[:d].strip.to_date
    end
 
    @yesterday = @today.yesterday
    @tomorrow = @today.tomorrow
    
    # find all unassigned tasks   
    @unassigned = current_user.tasks.find_unassigned(tasklist_id)

    # find all tasks where date is within range yesterday..tomorrow of given day
    @tasks = current_user.tasks.find_batch(tasklist_id, @yesterday, @tomorrow) 

    # don't need all this when using AJAX links
    unless params[:a] == 'i'
      # get list of all unique task bodies for autocomplete use (cache this query?)
      @bodies = current_user.tasks.all(:select => 'body', :group => 'body')     
      # get all active lists
      @tasklists = current_user.tasklists.all(:order => "title", :conditions => ["active = 1"])
      @current_list = Tasklist.find_by_id(current_user.current_list)
      @title = @current_list.title     
      @stat_unassigned = @unassigned.size     
      # find today's incomplete tasks (change this and use for achievements too)
      @alltasks = current_user.tasks.all(:conditions => ["duedate IN (?) AND completed = 0", Time.zone.now.to_date ])
    end
        
    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end
  
  def list
    @title = @view_title = t("tasks.managetasks")
    @tasks = current_user.tasks.all(:include => :tasklist, :order => "duedate, body")
    
    #page = params[:page] || 1
    #@tasks = current_user.tasks.paginate(:all, :page => page, :order => 'duedate', :per_page => 15)
    
    render :layout => "outside"
  end

  def show    
    tasklist_id = current_user.current_list
    @today = Time.zone.now.to_date
    
    # get tasklist
    @tasklist = Tasklist.find_by_id(tasklist_id)
    # add unassigned tasks if env_reporting in [ 2, 3, 6, 7 ]
    @unassigned = current_user.tasks.find_unassigned(tasklist_id)
    
    if [ 1, 3, 5, 7 ].include?(@tasklist.reporting)
      @items_by_month = current_user.tasks.find_batch(tasklist_id, @today, @today + 7.days).group_by { |item| item.duedate.strftime("%Y-%m-%d") }
    else
      @items_by_month = current_user.tasks.find_incomplete_batch(tasklist_id, @today, @today + 7.days).group_by { |item| item.duedate.strftime("%Y-%m-%d") }      
    end
    
    respond_to do |format|
      format.html
      format.js
      format.pdf    # create pdf   
    end
    
  end

  #todo: maintenance for all lists; create maintenance report
  def maintenance
    # do maintenance according to user preferences
    status_report = ""
    tasklists = current_user.tasklists.all(:conditions => ["active = 1"])
    count_today = 0 
    count_unassigned = 0
    tasklists.each do |a|
      case a.maintenance
      when 2
        # move incomplete overdue items to today and mark 
        current_user.tasks.find_overdue(a).each { |t| 
          t.update_attribute :duedate, Time.zone.now.to_date
          count_today += 1
        }
        #status_report += help.pluralize(count, t("tasks.maint_task"), t("tasks.maint_task_plural")) + t("tasks.maint_today") if count > 0   
      when 3
        # move to unassigned
        current_user.tasks.find_overdue(a).each { |t| 
          t.update_attribute :duedate, NEVER
          count_unassigned += 1
        }
        #status_report = count.to_s + t("tasks.maint_unassigned") if count > 0
        #status_report += help.pluralize(count, t("tasks.maint_task"), t("tasks.maint_task_plural")) + t("tasks.maint_unassigned") if count > 0
      end
    end
    # build status report
    #status_report += help.pluralize(count, t("tasks.maint_task"), t("tasks.maint_task_plural")) + t("tasks.maint_today") if count > 0   
    status_report = help.pluralize(count_today, t("tasks.maint_task"), t("tasks.maint_task_plural")) + t("tasks.maint_today") if count_today > 0
    status_report += help.pluralize(count_unassigned, t("tasks.maint_task"), t("tasks.maint_task_plural")) + t("tasks.maint_unassigned") if count_unassigned > 0

    # when logging in, also show login successfull message
    status_report = t("tasks.no_maint") if status_report == ""
    #flash[:notice] = t("tasks.maint_message") + status_report 
    redirect_to home_url, :notice => t("tasks.maint_message") + status_report 
  end

  # save sort order, also set new date (for connected lists)
  # adopted from http://henrik.nyh.se/2008/11/rails-jquery-sortables
  def sort
    order = params[:atask]
    newdate = params[:date]
    Task.order(order, newdate)
    render :text => order.inspect
  end

  # update a single task with its new completion status
  def checkcompleted
    status = params[:completed].to_i
    id = params[:id].gsub(/\D/,'').to_i    
    Task.checkitem(id, status)
    #render :text => status.inspect
    
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def remove
    id = params[:id]
    @task = current_user.tasks.find_by_id(id)
    unless @task.nil?
      @task.destroy
      flash[:notice] = t("tasks.removed")
    else
      flash[:notice] = t("tasks.notexist")
    end
    redirect_to "/list"
  end
  
  def destroy
    id = params[:id].gsub(/\D/,'').to_i    
    current_user.tasks.find_by_id(id).destroy
    render :text => id.inspect
  end

  def new
    @task = Task.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  def edit
    @title = t("tasks.edittask") 
    @task = current_user.tasks.find(params[:id])
    render :layout => "outside"
  end

  # todo: improve create performance
  def create    
    # use current_list id
    params[:task][:tasklist_id] = current_user.current_list
    @task = current_user.tasks.create(params[:task])
    
    # update global task count
    Stat.find(:first).increment!(:taskcount)
    
    if @task.save
      @addtype = @task.addtype
      flash[:notice] = t("tasks.created")  
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end  
    end  
  end

  # inline edit update
  def update
    if params[:body].empty?
      # change to 'unless'
    else
      body = params[:body].to_s
      id = params[:id].gsub(/\D/,'').to_i
      Task.updateBody(id, body)
      render :text => body
    end
  end


  # todo
  def search
    @tasks = current_user.tasks.search(params[:search])
  end
    
  # export to ical
  def export_ics
    #@event = Task.find(params[:id])
    @tasks = current_user.tasks.find_assigned(current_user.current_list)
    @calendar = Icalendar::Calendar.new    
    
    @tasks.each do |t|
     # add tasks
     event = Icalendar::Event.new
     event.start = t.duedate.strftime("%Y%m%dT%H%M%S")
     event.end = t.duedate.strftime("%Y%m%dT%H%M%S")
     event.summary = t.body
     event.description = t.body
     #event.location = @event.location 
     
     # add event to calendar
     @calendar.add event   
    end
    
    @calendar.publish
#    headers['Content-Type'] = "text/calendar; charset=UTF-8"
#    render :text => @calendar.to_ical, :layout => false    
    
    send_data(@calendar.to_ical,:type => 'text/calendar', :disposition =>
    'inline; filename=5things_' + Time.now.strftime("%m-%d-%Y") + '.ics', :filename => '5things_' + Time.now.strftime("%m-%d-%Y") + '.ics')
  end

  # export to csv
  def export_csv
    @tasks = current_user.tasks.find_assigned(current_user.current_list)
    @outfile = "5things_" + Time.now.strftime("%m-%d-%Y") + ".csv"

    csv_data = FasterCSV.generate do |csv|
      csv << [
      t("tasks.duedate"),
      t("tasks.task"),
      t("tasks.completed")
      ]
      @tasks.each do |t|
        csv << [
        t.duedate,
        t.body,
        t.completed
        ]
      end
    end

    send_data csv_data,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :disposition => "attachment; filename=#{@outfile}"

    flash[:notice] = t("tasks.export")
  end
  
  def find_today
    if current_user # fix bug with two open windows, then logging out one window
      alltasks = current_user.tasks.all(:conditions => ["duedate IN (?) AND completed = 0", Time.zone.now.to_date ])
      @todaycount = alltasks.size
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    else
      @todaycount = 0
    end
  end
  
  def set_help
    current_user.update_attributes(:env_other => 0)
  end
  
  def increment_taskcount
    Stat.find(:first).increment!(:taskcount, 1 + rand(6))
    render :nothing => true
  end
end