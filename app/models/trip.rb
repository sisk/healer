class Trip < ActiveRecord::Base
  validates_presence_of :country, :on => :save, :message => "can't be blank"
end
