class ActivationsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  layout "clean"

  def new
    init_page({title: t("activations.title")})
    @user = User.find_using_perishable_token(params[:activation_code], 2.hours)
    raise "exception" if @user.active?
    
    # invalid or expired token; or user is already active
    rescue
      @ft = "removed"
      @title = t("activations.title")
      @copy = t("activations.invalidtoken")
      render :template => "/shared/success"
  end

  def reset_token(user)
    init_page({title: t("activations.title"), footer: false})
    @user = User.find_by_email(params[:email])
    
    if @user.signup!(params)
      @user.reset_perishable_token
      UserMailer.password_reset_instructions(@user).deliver
      @copy = t("user.account_created")
      render :template => "/shared/success"
    else
      render :action => :new
    end
  end  

  def create
    @user = User.find(params[:id])
    raise Exception if @user.active?

    if @user.activate!(params)
      newlist = @user.tasklists.create(:title => t("user.firstlist"), :key => Tasklist.new_key)
      User.update(@user.id, :current_list => newlist.id)
      # create the first task and mark as completed
      newrecord = @user.tasks.new(:body => t("user.firstsignup"), :duedate => Time.zone.now, :completed => 1, :ordinal => 1, :tasklist_id => newlist.id)
      newrecord.save
            
      @user.reset_perishable_token
      UserMailer.activation_confirmation(@user).deliver      
      flash[:notice] = t("activations.success")
      redirect_to root_url
    else
      render :action => :new
    end
  end

end