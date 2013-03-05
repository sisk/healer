require 'spec_helper'

describe Role do
  should_validate_presence_of :name
end

describe Role, ".available" do
  it "returns a symbolized array of the expected values" do
    Role::available.should == %w(standard admin doctor nurse superuser anesthesiologist liaison).map{ |r| r.to_sym }
  end
end