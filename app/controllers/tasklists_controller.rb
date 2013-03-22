class TasklistsController < ApplicationController
  before_filter :require_user, :except => "show"
  layout "outside"

  def index
    init_page({title: t("lists.title")})
    @tasklists = current_user.tasklists.all(:order => 'title')
  end


  def show
    @tasklist = @view_title = Tasklist.find_by_key(params[:id])
    @hd = "removed"
    raise "not found" if @tasklist.blank?
    if @tasklist.security?

      @title = @tasklist.title
      @today = Time.zone.now.to_date

      @items_by_day = Task.find_upcoming(@tasklist.id).group_by { |item| item.duedate.strftime("%Y-%m-%d") }
      @unassigned = Task.find_unassigned(@tasklist.id)
      @all_items = Task.all(:order => 'duedate, ordinal ASC', :conditions => ["tasklist_id = (?)", @tasklist.id])

      render :layout => "share"
    else
      raise "not public"
    end

  rescue
    @ft = "removed"
    @title = t("lists.notfound")
    # add 404
    @copy = t("lists.errormessage") # + $!
    render :template => "/shared/success"
  end

  def new
    @title = @view_title = t("lists.createlist")
    @tasklist = Tasklist.new(:maintenance => current_user.env_maintenance)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  def edit
    @title = @view_title = t("lists.editlist")
    @tasklist = current_user.tasklists.find(params[:id])
  end

  def create
    @title = t("lists.createlist")
    params[:tasklist]['reporting'] = params['check_1'].to_i + params['check_2'].to_i + params['check_3'].to_i
    @tasklist = current_user.tasklists.create(params[:tasklist])
    if @tasklist.save
      flash[:notice] = t("lists.listcreated")
      respond_to do |format|
        format.html { redirect_to :action => 'index'}
        format.js
      end
    else
      render :action => 'new'
    end
  end

  # update task list details
  def update
    @title = @view_title = t("lists.editlist")
    @tasklist = Tasklist.find(params[:id])
    params[:tasklist]['reporting'] = params['check_1'].to_i + params['check_2'].to_i + params['check_3'].to_i
    if @tasklist.update_attributes(params[:tasklist])
      flash[:notice] = t("lists.listupdated")
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  # delete a list (may not be active and may not be the last list remaining)
  def destroy
    candidate = current_user.tasklists.find(params[:id])

    unless candidate.id == current_user.current_list
      current_user.tasklists.find(params[:id]).destroy
      flash[:notice] = t("lists.listremoved")
    else
      flash[:notice] = t("lists.removedisabled")
    end
  rescue
    flash[:notice] = t("lists.notexist")
  ensure
    redirect_to :action => 'index'
  end

end
