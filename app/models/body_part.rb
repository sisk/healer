class BodyPart < ActiveRecord::Base
  validates_presence_of :name, :message => "can't be blank"
  has_many :diagnoses
  validates_inclusion_of :side, :in => ["L", "R", ""], :allow_nil => true
  default_scope :order => 'body_parts.name, body_parts.side'
  
  def to_s
    str = name
    str << " (#{side})" unless side.blank?
    str
  end
  
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

