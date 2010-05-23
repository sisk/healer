class BodyPart < ActiveRecord::Base
  validates_presence_of :name, :on => :save, :message => "can't be blank"
end
