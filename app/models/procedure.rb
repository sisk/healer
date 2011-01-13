class Procedure < ActiveRecord::Base
  validates_presence_of :base_name
  has_many :operations
  default_scope :order => 'procedures.display_order'

  def to_s
    base_name
  end

end
