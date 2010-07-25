class BodyPart < ActiveRecord::Base
  validates_presence_of :name, :message => "can't be blank"
  has_many :diagnoses
  validates_inclusion_of :side, :in => %w(L R), :allow_nil => true
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

