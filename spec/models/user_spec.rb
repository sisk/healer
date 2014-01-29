# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User, ".languages" do
  it "returns expected values" do
    User::languages.should == {"en" => "English", "es" => "Español"}
  end
end

describe User, "#name" do
  before(:each) do
    @user = User.new
  end
  it "returns First Last if no arguments are passed" do
    @user.name_first = "First"
    @user.name_last = "Last"
    @user.name.should == "First Last"
  end
  it "returns Last, First if :last_first is an argument" do
    @user.name_first = "First"
    @user.name_last = "Last"
    @user.name(:last_first => true).should == "Last, First"
  end
end

describe User, "#to_s" do
  before(:each) do
    @user = User.new
  end
  describe "#to_s" do
    it "returns the value of name with no arguments" do
      @user.stub(:name).and_return("Derp")
      @user.to_s.should == "Derp"
    end
    it "returns the value of name with arguments" do
      @user.stub(:name)
      @user.stub(:name).with(:last_first => true).and_return("Derp")
      @user.to_s(:last_first => true).should == "Derp"
    end
  end
end


describe User do
  before(:each) do
    @user = User.new
  end
  describe "#role_symbols" do
    it "returns a downcased symbolized list of associate role names" do
      @roles = [double(Role, :name => "Admin"), double(Role, :name => "Super Duper")]
      @user.stub(:roles).and_return(@roles)
      @user.role_symbols.should == [:admin, :super_duper]
    end
  end
  Role.available.map{ |rr| rr.to_s }.each do |role|
    describe "#has_role_#{role}" do
      it "returns true if user has #{role} role" do
        @roles = [double(Role, :name => role)]
        @user.stub(:roles).and_return(@roles)
        @user.send("has_role_#{role}").should be_true
      end
      it "returns false if user does not have #{role} role" do
        @roles = [double(Role, :name => "Not #{role}")]
        @user.stub(:roles).and_return(@roles)
        @user.send("has_role_#{role}".to_sym).should be_false
      end
    end
    describe "#has_role_#{role}=" do
      before(:each) do
        @role = stub_model(Role, :name => role)
        Role.stub(:find_by_name).with(role).and_return(@role)
      end
      it "assigns #{role} role to user if sent 1" do
        @user.send("has_role_#{role}=".to_sym, "1")
        @user.roles.any?{ |r| r.name == role }.should be_true
      end
      it "revokes role #{role} from user if sent zero" do
        @user.send("has_role_#{role}=".to_sym, "0")
        @user.roles.any?{ |r| r.name == role }.should be_false
      end
    end
  end

end