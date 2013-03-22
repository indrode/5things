class IntroController < ApplicationController
  layout "outside"
  before_filter :redirect_if_logged_in
  caches_page :index
 
  def index
    init_page({title: t("pages.intro")})
  end

  def about
    init_page({title: t("pages.about")})
  end
  
  def privacy
    init_page({title: t("pages.privacy")})
  end
  
  def terms
    init_page({title: t("pages.terms")})
  end
  
  def help
    init_page({title: t("common.help")})
  end
  
  def notfound
    init_page({title: "Error 404", footer: false, copy: t("common.error404")})
    render :template => "/shared/error", :status => 404
  end
end