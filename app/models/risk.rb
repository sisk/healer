# TODO make name distinct
class Risk < ActiveRecord::Base
  has_many :risk_factors
  validates_presence_of :name
  default_scope :order => 'risks.display_order'

  def to_s
    name
  end

end
