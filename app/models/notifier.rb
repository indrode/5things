class Notifier < ActionMailer::Base
  
  # email sent after a user has initiated registration
  def activation_instructions(user)
    subject       I18n.t("email.activation_instructions")
    from          I18n.t("email.admin_email")
    bcc           ["indro.de@gmail.com"]
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.perishable_token)
  end

  # email sent after a user has finished the registration process
  def activation_confirmation(user)
    subject       I18n.t("email.welcome")
    from          I18n.t("email.admin_email")
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end

  # email sent after a user has initiated a password reset
  def password_reset_instructions(user)  
    subject       I18n.t("email.pw_reset")  
    from          I18n.t("email.admin_email")  
    recipients    user.email  
    sent_on       Time.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end

  # email sent to people for sharing a list link
  def sharedlist_link(user)
    subject       I18n.t("email.sharelink")
    from          user.email
    recipients    email_params[:email]
    sent_on       Time.now
    body          :message => emailparams(:body)
  end
    
  # email sent to admin through the feedback function
  def contact(email_params)
    subject       I18n.t("email.feedback")  
    from          I18n.t("email.admin_email")  
    recipients    "contact@zenpunch.com"  
    sent_on       Time.now  
    body          :message => email_params[:body], :type => email_params[:type], :email => email_params[:email], :name => email_params[:name]
  end

end