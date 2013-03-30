class UserManager
  include TaskUtils

  # tested in spec/acceptance/signup_spec.rb
  def initialize!(user)
    newlist = user.tasklists.create(
      :title => t("user.firstlist"),
      :key => new_key
    )
    user.current_list = newlist.id
    user.save

    newrecord = user.tasks.new(
      :body => t("user.firstsignup"),
      :duedate => Time.zone.now,
      :completed => 1,
      :ordinal => 1,
      :tasklist_id => newlist.id
    )
    newrecord.save
    
    user.reset_perishable_token
    UserMailer.activation_confirmation(user).deliver 
  end

end