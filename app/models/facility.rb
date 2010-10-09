class Facility < ActiveRecord::Base
  validates_presence_of :name
  has_many :operating_rooms
end
