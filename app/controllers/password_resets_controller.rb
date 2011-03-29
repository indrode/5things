class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user 
  layout "clean"
  
  def new
    @ft = "removed"
    @title = t("pwreset.title") 
    render
  end
  
  def create
    @ft = "removed"
    @title = t("pwreset.changetitle")
    @user = User.find_by_email(params[:Email])
    if @user
      @user.reset_perishable_token
      @user.deliver_password_reset_instructions!
      @copy = t("pwreset.instructions")
      render :template => "/shared/success"
    else
      flash[:notice] = t("pwreset.notfound")
      render :action => :new
    end
  end
  
  def edit
    @ft = "removed"
    @title = t("pwreset.changetitle")  
  end  
    
  def update  
    @user.password = params[:user][:password]  
    @user.password_confirmation = params[:user][:password_confirmation]  
    
    if @user.password.blank?
      flash[:notice] = t("pwreset.fail")
      render :action => :edit and return
    end 
    if @user.save  
      flash[:notice] = t("pwreset.success")  
      redirect_to home_path  
    else  
      render :action => :edit  
    end  
  end  
  
  def success
    @ft = "removed"
    @title = t("pwreset.changetitle")  
  end
    
  private  
  def load_user_using_perishable_token  
    @user = User.find_using_perishable_token(params[:id])  
    unless @user  
      flash[:notice] = t("pwreset.invalidtoken")  
      redirect_to root_url  
    end  
  end

end