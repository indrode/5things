class IntroController < ApplicationController
  layout "outside"
  before_filter :redirect_if_logged_in
  caches_page :index
 
  def index
    @title = t("pages.intro")
    # @view_title = "#{Task.count} tasks added so far!"
  end

  def about
    @title = @view_title = t("pages.about")  
  end
  
  def privacy
    @title = @view_title = t("pages.privacy")  
  end
  
  def terms
    @title = @view_title = t("pages.terms")
  end
  
  def help
    @title = @view_title = t("common.help")
  end
  
  def notfound
    @title = @view_title = "Error 404"
    @copy = t("common.error404")
    @ft = "removed"
    # to do: remove /intro/notfound.html.erb
    render :template => "/shared/error", :status => 404
  end
  
  private
  def redirect_if_logged_in
    if current_user_session
      redirect_to home_path
    end
  end
end