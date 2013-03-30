require 'spec_helper'

describe User do
  let(:user) { User.new }

  describe "#has_no_credentials" do
    it "should return true if password is empty" do
      user.has_no_credentials?.should be_true
    end

    it "should return false if user has password" do
      user.stub(:crypted_password).and_return "123"
      user.has_no_credentials?.should be_false
    end
  end

  describe "#signup!" do
    it "should set email" do
      user.signup!(:user => {:email => "some@email.com"})
      user.email.should == "some@email.com"
    end
  end

  describe "#activate!" do
    it "should user params" do
      params = {
        :user => {
          :password => "password",
          :password_confirmation => "password",
          :time_zone => "time zone",
          :language => "en"
        }
      }

      user.activate!(params)
      user.active.should be_true
      user.password.should == "password"
      user.password_confirmation.should == "password"
      user.time_zone.should == "time zone"
      user.language == "language"
    end
  end

  describe "#active?" do
    it "should return active status true" do
      user.stub(:active => true)
      user.should be_active
    end

    it "should return active status false" do
      user.stub(:active => false)
      user.should_not be_active
    end
  end

  describe "#current_tasklist" do
    it "should return a Tasklist object" do
      Tasklist.stub(:find).and_return Tasklist.new
      list = user.current_tasklist
      list.should be_a_kind_of(Tasklist)
    end
  end
end