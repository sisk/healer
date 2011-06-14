class Room < ActiveRecord::Base
  belongs_to :facility
  validates_presence_of :facility
  has_many :operations, :dependent => :nullify
  has_many :patient_cases, :dependent => :nullify
  default_scope :order => 'rooms.display_order'
  
  def to_s
    title
  end
end
