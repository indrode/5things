class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  layout "outside"

  
  def new
    @title = @view_title = t("common.login")      
    
    @ft = "removed"
    @user_session = UserSession.new
  end

  def create  
    @title = t("common.login")
    @ft = "removed"
    # next line can be removed
    Stat.find(:first).increment!(:taskcount)
    @user_session = UserSession.new(params[:user_session]) 
    #@current_list = current_user.default_list
    if @user_session.save
      flash[:notice] = t("session.login")    
      redirect_to :action => 'maintenance', :controller => 'tasks'
    else  
      render :action => :new  
    end  
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = t("session.logout")
    redirect_to root_url
  end
  
end
