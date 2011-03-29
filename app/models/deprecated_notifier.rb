# ActionMailer class completely rewritten for Rails 3
class Notifier < ActionMailer::Base
  default :from => "5thingsapp@googlemail.com"
  
  def activation_instructions(recipient)
    @account = recipient

    #attachments['an-image.jp'] = File.read("an-image.jpg")
    #attachments['terms.pdf'] = {:content => generate_your_pdf_here() }

    mail(:to => recipient.email,
         :bcc => $admin_email,
         :subject => "New account information")
  end
end