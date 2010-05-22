require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Trip do
  it_has_the_attribute :start, :type => :date
  it_has_the_attribute :end, :type => :date
  it_has_the_attribute :country, :type => :string
  it_has_the_attribute :city, :type => :string
  it{should validate_presence_of(:country)}
end
