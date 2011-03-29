class ApplicationController < ActionController::Base  
  helper :all
  helper_method :current_user_session, :current_user
  before_filter :set_user_language, :set_user_time_zone, :mailer_set_url_options
  after_filter :store_location
    
  protect_from_forgery

  private
  def set_user_time_zone
    Time.zone = current_user.time_zone if current_user
  end

  private  
  def current_user_session  
    return @current_user_session if defined?(@current_user_session)  
    @current_user_session = UserSession.find  
  end

  private  
  def set_user_language  
    I18n.locale = current_user.language if current_user
  end
    
  def current_user_id
    @current_user_id = current_user.id
  end
  
  def current_user  
    @current_user = current_user_session && current_user_session.record  
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = t("application.loginrequired")
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = t("application.logoutrequired")
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def rescue_action_in_public(exception)
    # todo: add debug data to put in error page
    case exception
      when ActionController::InvalidAuthenticityToken
      when ArgumentError
      when SyntaxError
        # change this:
        @ft = "removed"
        @title = "Error 500"
        @view_title = '&nbsp;'
        @copy = t("common.error500")
        render :template => "/shared/error", :layout => "outside", :status => 500
        
        #render :template => "shared/error500", :layout => "outside", :status => "500"
      else
        @ft = "removed"
        @title = "Error 500"
        @view_title = '&nbsp;'
        @copy = t("common.error500")
        render :template => "/shared/error", :layout => "outside", :status => 500
        
        #render :template => "shared/error500", :layout => "outside", :status => "500"
    end          
  end

  # allow helpers in controller
  def help
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::TextHelper
  end

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
end