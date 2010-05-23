class Role < ActiveRecord::Base
  acts_as_authorization_role
  validates_presence_of :name, :on => :save, :message => "can't be blank"
end
