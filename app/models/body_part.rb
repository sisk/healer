class BodyPart < ActiveRecord::Base

  @@all_body_parts ||= all

  validates_presence_of :name_en, :message => "can't be blank"
  belongs_to :mirror, :class_name => "BodyPart", :foreign_key => "mirror_id"
  validates_inclusion_of :side, :in => ["L", "R", ""], :allow_nil => true
  default_scope :order => 'body_parts.name_en, body_parts.side'

  after_save :sync_mirror

  def to_s
    str = display_name
    str += " (#{I18n.locale.to_sym == :es ? side_es : side})" unless side.blank?
    str
  end

  def display_name
    (I18n.locale.to_sym == :es && name_es.present?) ? name_es : name_en
  end

  private #####################################################################

  def all_body_parts
    @@all_body_parts
  end

  def side_es
    return "I" if side.downcase == "l" # izquierda
    return "D" if side.downcase == "r" # derecha
    nil
  end

  def sync_mirror
    mirror.update_attributes(:mirror => self) if mirror.present? && mirror.mirror_id != self.id
  end

end

# == Schema Information
#
# Table name: body_parts
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

