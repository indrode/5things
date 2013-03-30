require_relative '../../app/modules/task_utils.rb'

describe TaskUtils do
  class DummyClass; end

  before(:all) do
    @dummy = DummyClass.new
    @dummy.extend TaskUtils
  end

  describe ".new_key" do
    it "should create a random key with length 20" do
      @dummy.new_key.size.should == 20
      @dummy.new_key.should be_a_kind_of(String)
    end

    it "should create a custom-sized key" do
      @dummy.new_key(30).size.should == 30
    end
  end
end