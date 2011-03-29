# app/controllers/contact_controller.rb

class ContactController < ApplicationController
  #before_filter :require_user 
  layout "outside"
  
  # sends a contact email to admin -> must be logged in
  # passes: email
  # user enters: body, type of contact (feedback, bug report, support request, other)
  
  def index
    @title = @view_title = t("contact.title")      
    #@ft = "removed"
    # this is also done inline in toolbar
  end

  def create
    # todo: everything
    @contact = params[:contact]
    UserMailer.contact(@contact).deliver
    flash[:notice] = t("contact.success")
    redirect_to root_url
  end

end