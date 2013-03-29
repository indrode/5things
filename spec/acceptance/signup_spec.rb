require 'acceptance_spec_helper'

describe "New user signup" do
  it "should be able to navigate to registration page" do
    visit_root
    click_link('sign_up_now')
    page.should have_content('Registration')
  end

  it "should create a new user record on signup." do
    expect { signup_user "test@5thingsapp.com" }.to change(User, :count).by(1)      
  end

  it "should generate a new tasklist and task for the user"
  it "should send out an activation confirmation"  
  it "should be able to request reset instructions"
  it "should be able to reset his password"
end