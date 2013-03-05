require 'spec_helper'

describe Role do
  should_validate_presence_of :name
end

describe Role, ".available" do
  it "returns a symbolized array of the expected values" do
    Role::available.should == [:standard, :doctor, :nurse, :scheduler, :anesthesiologist, :liaison, :admin, :superuser]
  end
end