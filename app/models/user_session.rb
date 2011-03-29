# app/models/user_session.rb

class UserSession < Authlogic::Session::Base
  generalize_credentials_error_messages true
  #self.logout_on_timeout = true   # logs out after inactivity (see user.rb)
  #self.remember_me = true
end