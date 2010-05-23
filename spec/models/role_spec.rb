require 'spec_helper'

describe Role do
  it_has_the_attribute :name, :type => :string
  it_has_the_attribute :authorizable_type, :type => :string
  it_has_the_attribute :authorizable_id, :type => :integer
  it{should validate_presence_of(:name)}
end
