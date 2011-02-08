require 'spec_helper'

describe Role do
  should_validate_presence_of :name
end

describe Role, ".available" do
  it "returns a symbolized array of the expected values" do
    Role::available.should == %w(admin doctor nurse superuser anesthesiologist).map{ |r| r.to_sym }
  end
end

# == Schema Information
#
# Table name: roles
#
#  id                :integer(4)      not null, primary key
#  name              :string(40)      not null
#  authorizable_type :string(40)
#  authorizable_id   :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#

