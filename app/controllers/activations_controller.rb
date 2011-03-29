# app/controllers/activations_controller.rb

class ActivationsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  layout "clean"

  def new
    @title = t("activations.title")
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
    @ft = "removed"
    @title = t("user.registration")
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
      # create the first list and set as current_list
      s = ""
      20.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
      newlist = @user.tasklists.new(:title => t("user.firstlist"), :key => s)
      newlist.save
      User.update(@user.id, :current_list => newlist.id)
      # create the first task and mark as completed
      newrecord = @user.tasks.new(:body => t("user.firstsignup"), :duedate => Time.zone.now, :completed => 1, :ordinal => 1, :tasklist_id => newlist.id)
      newrecord.save
      
      # update global task count
      Stat.find(:first).increment!(:taskcount)
      
      @user.reset_perishable_token
      UserMailer.activation_confirmation(@user).deliver      
      flash[:notice] = t("activations.success")
      redirect_to root_url
    else
      render :action => :new
    end
  end

end