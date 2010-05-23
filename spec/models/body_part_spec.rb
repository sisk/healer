require 'spec_helper'

describe BodyPart do
  it_has_the_attribute :name, :type => :string
  it{should validate_presence_of(:name)}
end
