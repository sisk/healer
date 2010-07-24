require 'spec_helper'

describe BodyPart do
  should_have_column :name, :type => :string
  should_validate_presence_of :name

  should_have_many :diagnoses
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

