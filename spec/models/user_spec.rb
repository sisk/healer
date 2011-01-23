# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  should_validate_presence_of :email
  should_validate_presence_of :name_first
  should_validate_presence_of :name_last
  should_have_column :language, :type => :string
end

describe User, ".languages" do
  it "returns expected values" do
    User::languages.should == {"en" => "English", "es" => "Español"}
  end
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
  describe "#role_symbols" do
    it "returns a downcased symbolized list of associate role names" do
      @roles = [mock_model(Role, :name => "Admin"), mock_model(Role, :name => "Super Duper")]
      @user.stub(:roles).and_return(@roles)
      @user.role_symbols.should == [:admin, :super_duper]
    end
  end
  describe "#has_role_admin" do
    it "returns true if user has admin role" do
      @roles = [mock_model(Role, :name => "Admin")]
      @user.stub(:roles).and_return(@roles)
      @user.has_role_admin.should be_true
    end
    it "returns false if user does not have admin role" do
      @roles = [mock_model(Role, :name => "Not Admin")]
      @user.stub(:roles).and_return(@roles)
      @user.has_role_admin.should be_false
    end
  end
  describe "#has_role_admin=" do
    before(:each) do
      @admin_role = stub_model(Role, :name => "admin")
      Role.stub!(:find_by_name).with("admin").and_return(@admin_role)
    end
    it "assigns admin role to user if sent 1" do
      @user.has_role_admin=("1")
      @user.roles.any?{ |role| role.name == "admin" }.should be_true
    end
    it "revokes role admin from user if sent zero" do
      @user.has_role_admin=("0")
      @user.roles.any?{ |role| role.name == "admin" }.should be_false
    end
  end
  describe "#has_role_doctor" do
    it "returns true if user has doctor role" do
      @roles = [mock_model(Role, :name => "doctor")]
      @user.stub(:roles).and_return(@roles)
      @user.has_role_doctor.should be_true
    end
    it "returns false if user does not have doctor role" do
      @roles = [mock_model(Role, :name => "Not doctor")]
      @user.stub(:roles).and_return(@roles)
      @user.has_role_doctor.should be_false
    end
  end
  describe "#has_role_doctor=" do
    before(:each) do
      @doctor_role = stub_model(Role, :name => "doctor")
      Role.stub!(:find_by_name).with("doctor").and_return(@doctor_role)
    end
    it "assigns doctor role to user if sent 1" do
      @user.has_role_doctor=("1")
      @user.roles.any?{ |role| role.name == "doctor" }.should be_true
    end
    it "revokes role doctor from user if sent zero" do
      @user.has_role_doctor=("0")
      @user.roles.any?{ |role| role.name == "doctor" }.should be_false
    end
  end
  describe "#has_role_nurse" do
    it "returns true if user has nurse role" do
      @roles = [mock_model(Role, :name => "nurse")]
      @user.stub(:roles).and_return(@roles)
      @user.has_role_nurse.should be_true
    end
    it "returns false if user does not have nurse role" do
      @roles = [mock_model(Role, :name => "Not nurse")]
      @user.stub(:roles).and_return(@roles)
      @user.has_role_nurse.should be_false
    end
  end
  describe "#has_role_nurse=" do
    before(:each) do
      @nurse_role = stub_model(Role, :name => "nurse")
      Role.stub!(:find_by_name).with("nurse").and_return(@nurse_role)
    end
    it "assigns nurse role to user if sent 1" do
      @user.has_role_nurse=("1")
      @user.roles.any?{ |role| role.name == "nurse" }.should be_true
    end
    it "revokes role nurse from user if sent zero" do
      @user.has_role_nurse=("0")
      @user.roles.any?{ |role| role.name == "nurse" }.should be_false
    end
  end
  describe "#has_role_superuser" do
    it "returns true if user has superuser role" do
      @roles = [mock_model(Role, :name => "superuser")]
      @user.stub(:roles).and_return(@roles)
      @user.has_role_superuser.should be_true
    end
    it "returns false if user does not have superuser role" do
      @roles = [mock_model(Role, :name => "Not superuser")]
      @user.stub(:roles).and_return(@roles)
      @user.has_role_superuser.should be_false
    end
  end
  describe "#has_role_superuser=" do
    before(:each) do
      @superuser_role = stub_model(Role, :name => "superuser")
      Role.stub!(:find_by_name).with("superuser").and_return(@superuser_role)
    end
    it "assigns superuser role to user if sent 1" do
      @user.has_role_superuser=("1")
      @user.roles.any?{ |role| role.name == "superuser" }.should be_true
    end
    it "revokes role superuser from user if sent zero" do
      @user.has_role_superuser=("0")
      @user.roles.any?{ |role| role.name == "superuser" }.should be_false
    end
  end
end
