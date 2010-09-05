class Risk < ActiveRecord::Base
  has_many :risk_factors
  validates_presence_of :name
  default_scope :order => 'risks.display_order'
  def to_s
    name
  end
  def self.order(ids)
    update_all(
      ['display_order = FIND_IN_SET(id, ?)', ids.join(',')],
      { :id => ids }
    )
  end
end
