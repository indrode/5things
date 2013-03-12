require 'spec_helper'

describe "Hello World!" do
  let(:something) { mock("some thing", a: true) }
  
  it "should do something" do
    something.a.should be_true  
  end
end