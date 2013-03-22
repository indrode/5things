require 'spec_helper'

# extract into elsewhere
def visit_root
  visit ('/')
end

describe "Signup" do
  context "New user" do
    it "should be able to navigate to registration page" do
      visit_root
      click_link('sign_up_now')
      page.should have_content('Registration')
    end

    it "should be able to sign up" do
      visit('/users/new')
      fill_in('user_email', :with => 'test@5thingsapp.com')
      click_button('Register')
      page.should have_content('Your account has been created!')
    end

    it "should add a new user"
    it "should generate a new tasklist for the user"
    it "should send out an activation confirmation"  
  end

  describe "Resetting a password" do
    it "should send reset instructions"
    it "should reset user's password"
  end
end