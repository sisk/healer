class Room < ActiveRecord::Base
  belongs_to :facility
  validates_presence_of :facility
  has_many :operations, :dependent => :nullify
  has_many :registrations, :dependent => :nullify
  
  def to_s
    title
  end
end
