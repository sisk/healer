require 'spec_helper'

describe Role do
  it_has_the_attribute :name, :type => :string
  it_has_the_attribute :authorizable_type, :type => :string
  it_has_the_attribute :authorizable_id, :type => :integer
  it{should validate_presence_of(:name)}
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

