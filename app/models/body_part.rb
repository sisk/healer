class BodyPart < ActiveRecord::Base

  @@all_body_parts ||= all

  validates_presence_of :name_en, :message => "can't be blank"
  has_many :diagnoses
  validates_inclusion_of :side, :in => ["L", "R", ""], :allow_nil => true
  default_scope :order => 'body_parts.name_en, body_parts.side'

  def to_s
    str = display_name
    str += " (#{I18n.locale.to_sym == :es ? side_es : side})" unless side.blank?
    str
  end

  def display_name
    (I18n.locale.to_sym == :es && name_es.present?) ? name_es : name_en
  end

  def has_mirror?
    side.present?
  end

  def mirror
    all_body_parts.select{ |bp| (bp.name_en == name_en && bp.side != side) }.first
  end

  private

  def all_body_parts
    @@all_body_parts
  end
  
  def side_es
    return "Z" if side.downcase == "l" # zurdo
    return "D" if side.downcase == "r" # diestro
    nil
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

