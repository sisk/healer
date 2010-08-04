class Disease < ActiveRecord::Base
  validates_presence_of :base_name
  has_many :diagnoses
  default_scope :order => 'diseases.display_order'
  def to_s
    base_name
  end
  def self.order(ids)
    update_all(
      ['display_order = FIND_IN_SET(id, ?)', ids.join(',')],
      { :id => ids }
    )
  end
end
