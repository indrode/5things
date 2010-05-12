# app/controllers/intro_controller.rb

class IntroController < ApplicationController
  layout "outside"
 
  def index
    @title = t("pages.intro")
    @view_title = Stat.find(:first).taskcount.to_s + ' tasks added so far!'
    if current_user_session
      redirect_to home_path
    end
    
  end

  def about
    #@ft = "removed"
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
  
end