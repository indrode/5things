# app/models/user.rb

class User < ActiveRecord::Base  
  attr_accessible :email, :password, :password_confirmation, :language, :time_zone, :env_maintenance, :env_reporting, :current_list
  has_many :tasks, :dependent => :destroy
  has_many :tasklists, :dependent => :destroy

  acts_as_authentic do |c|
    c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
    c.validates_length_of_password_confirmation_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
    #c.merge_validates_confirmation_of_password_field_options :message => t("user.validatefail")
    c.disable_perishable_token_maintenance(true)
    #c.logged_in_timeout(30.seconds)     #logs out after 30 minutes of inactivity   
  end  

  def has_no_credentials?
    self.crypted_password.blank?
  end

  def signup!(params)
    self.email = params[:user][:email]
    save_without_session_maintenance
  end

  def activate!(params)
    self.active = true
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    self.time_zone = params[:user][:time_zone]
    self.language = params[:user][:language]
    save
  end

  def active?
    active
  end
  
  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end
  
  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end

  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end

end