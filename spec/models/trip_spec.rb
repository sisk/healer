require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Trip do
  it_has_the_attribute :start, :type => :date
  it_has_the_attribute :end, :type => :date
  it_has_the_attribute :country, :type => :string
  it_has_the_attribute :city, :type => :string
  it{should validate_presence_of(:country)}
end

# == Schema Information
#
# Table name: trips
#
#  id         :integer(4)      not null, primary key
#  start      :date
#  end        :date
#  country    :string(255)     not null
#  city       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

