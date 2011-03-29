class UserMailer < ActionMailer::Base
  default :from => "5thingsapp@googlemail.com",
          :bcc => "indro.de@gmail.com"
  
  def activation_instructions(recipient)
    @account_activation_url = register_url(recipient.perishable_token)
    mail(:to => recipient.email,
         :subject => t("email.activation_instructions"))
  end
  
  def activation_confirmation(recipient)
    @root_url = root_url
    mail(:to => recipient.email,
         :subject => t("email.welcome"))
  end
  
  def password_reset_instructions(recipient)
    @edit_password_reset_url = edit_password_reset_url(recipient.perishable_token) 
    mail(:to => recipient.email,
         :subject => t("email.activation_instructions"))
  end
  
  # email sent to admin through the feedback function
  def contact(recipient)  
    @body = recipient[:message]
    @type = recipient[:type]
    @email = recipient[:email]
    @name = recipient[:name]
    mail(:to => "indro.de@gmail.com", :subject => t("email.feedback"))
  end

end