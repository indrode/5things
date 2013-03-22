class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :resend]
  before_filter :require_user, :only => [:show, :edit, :update, :delete, :preferences, :set_list]
  layout "outside"

  def new
    init_page({title: t("user.registration")})
    @user = User.new 
    render :layout => "outside"
  end

  def create
    init_page({title: t("user.registration"), footer: false})

    @user = User.new    
    if @user.signup!(params)
      @user.reset_perishable_token!
      UserMailer.activation_instructions(@user).deliver    
            
      @copy = t("user.account_created").html_safe
      render :template => "/shared/success"
    else
      render :action => :new
    end
  end
  
  def resend
    init_page({title: t("user.registration"), footer: false})
    @user = User.new    
  end
  
  def rs
    init_page({title: t("user.registration"), footer: false})
    @user = User.find_by_email(params[:user]['email'])
    unless @user.nil?
      if @user.active?
        @copy = t("user.alreadyactive")
      else
        @user.reset_perishable_token!
        UserMailer.activation_instructions(@user).deliver       
        @copy = "#{t("user.newactivationsent")} #{params[:user]['email']}"
      end
    else
      @copy = t("user.emailnotfound")
    end
    render :template => "/shared/success", :layout => "clean"
  end

  def show
    init_page({title: t("user.account_settings")})
    @user = current_user
    render :action => :edit
  end
  
  def edit
    @user = current_user   
  end 
  
  def preferences
    init_page({title: t("user.preferences")})
    @user = current_user   
  end 
    
  def update    
    @user = current_user
    if params[:user][:page] == "prefs"
      params[:user]['env_reporting'] = params['check_1'].to_i + params['check_2'].to_i + params['check_3'].to_i
      # change to add more env settings
      params[:user]['env_other'] = params['check_help'].to_i
    end
    
    @user.reset_perishable_token
    if @user.update_attributes(params[:user])  
      #flash[:notice] = t("user.updated")
      redirect_to home_url, :notice => t("user.updated")
    else  
      render :action => :edit  
    end  
  end

  def delete
    current_user.destroy  
    #flash[:notice] = t("user.deleted")
    redirect_to home_path, :notice => t("user.deleted")   
  end
  
  def destroy
    #current_user.destroy!  
    #flash[:notice] = t("user.deleted")
    redirect_to home_path, :notice => t("user.deleted")
  end

  def success
    init_page({title: t("user.registration"), footer: false})
  end
  
  # update current task list
  def set_list
    @user = current_user
    if @user.tasklists.find_by_id(params[:id], :conditions => ["active = 1"])
      User.update(current_user.id, :current_list => params[:id])
      #redirect_to "/maintenance" and return
    end
    redirect_to home_path
  end
end