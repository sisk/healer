class Room < ActiveRecord::Base
  belongs_to :facility
  validates_presence_of :facility
  has_many :operations
  
  def to_s
    title
  end
end
