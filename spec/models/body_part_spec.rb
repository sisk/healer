require 'spec_helper'

describe BodyPart do
  it_has_the_attribute :name, :type => :string
  it{should validate_presence_of(:name)}
end

# == Schema Information
#
# Table name: body_parts
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

