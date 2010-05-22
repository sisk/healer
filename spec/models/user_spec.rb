require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  it_should_behave_like 'authlogic_model'
  it{should validate_presence_of(:login)}
  it{should validate_presence_of(:name_first)}
  it{should validate_presence_of(:name_last)}
end

describe User do
  before(:each) do
    @user = User.new
  end
  describe "#name" do
    it "returns First Last if no arguments are passed" do
      @user.name_first = "First"
      @user.name_last = "Last"
      @user.name.should == "First Last"
    end
    it "returns Last, First if :last_first is an argument" do
      @user.name_first = "First"
      @user.name_last = "Last"
      @user.name(:last_first).should == "Last, First"
    end
  end
  describe "#to_s" do
    it "returns the value of name with no arguments" do
      @user.stub(:name).and_return("Derp")
      @user.to_s.should == "Derp"
    end
    it "returns the value of name with arguments" do
      @user.stub(:name)
      @user.stub(:name).with(:last_first).and_return("Derp")
      @user.to_s(:last_first).should == "Derp"
    end
  end
end