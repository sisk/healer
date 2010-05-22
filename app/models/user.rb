class User < ActiveRecord::Base
  validates_presence_of :login, :on => :create, :message => "can't be blank"
  validates_presence_of :name_first, :on => :create, :message => "can't be blank"
  validates_presence_of :name_last, :on => :create, :message => "can't be blank"
end
