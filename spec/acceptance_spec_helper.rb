require 'spec_helper'

def visit_root
  visit ('/')
end

def signup_user(email)
  visit('/users/new')
  fill_in('user_email', :with => email)
  click_button('Register')
  page.should have_content('Your account has been created!')
end