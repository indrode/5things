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
    # todo: use hidden field spambot protection
    if Notifier.deliver_contact(params[:contact])
      flash[:notice] = t("contact.success")
      redirect_to root_path
    else
      flash.now[:error] = t("contact.fail")
      render :index
    end
  end

end