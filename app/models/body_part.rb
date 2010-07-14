class BodyPart < ActiveRecord::Base
  validates_presence_of :name, :message => "can't be blank"
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

