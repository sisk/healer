class Disease < ActiveRecord::Base
  validates_presence_of :name_en
  has_many :diagnoses
  default_scope :order => 'diseases.display_order'

  def to_s
    (I18n.locale.to_sym == :es && name_es.present?) ? name_es : name_en
  end

  # def self.order(ids)
  #   update_all(
  #     ['display_order = FIND_IN_SET(id, ?)', ids.join(',')],
  #     { :id => ids }
  #   )
  # end

end
