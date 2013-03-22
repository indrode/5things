require 'spec_helper'

describe Tasklist do
  
  describe ".new_key" do
    let(:key) { Tasklist.new_key }
    it "should create a random key with length 20" do
      key.size.should == 20
      key.should be_a_kind_of(String)
    end

    it "should create a custom-sized key" do
      Tasklist.new_key(30).size.should == 30
    end
  end
end