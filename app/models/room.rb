class Room < ActiveRecord::Base
  belongs_to :facility
  validates_presence_of :facility
  has_many :operations
  has_many :registrations
  
  def to_s
    title
  end
end
