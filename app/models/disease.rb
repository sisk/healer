class Disease < ActiveRecord::Base
  validates_presence_of :name_en
  default_scope :order => 'diseases.display_order'

  def to_s
    (I18n.locale.to_sym == :es && name_es.present?) ? name_es : name_en
  end
end
