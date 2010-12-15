class Diagnosis < ActiveRecord::Base
  def self.severity_table
    { 0 => "Unremarkable", 1 => "Mild", 2 => "Moderate", 3 => "Severe" }
  end
  belongs_to :patient
  belongs_to :registration
  belongs_to :disease
  belongs_to :body_part
  has_many :operations # might just be has_one. TBD.
  has_many :xrays, :dependent => :destroy
  accepts_nested_attributes_for :xrays, :allow_destroy => true, :reject_if => proc { |attributes| attributes['photo'].blank? }
  
  validates_presence_of :patient
  validates_presence_of :disease
  validates_numericality_of :severity
  validates_inclusion_of :severity, :in => self.severity_table.keys

  default_scope :order => 'diagnoses.assessed_date DESC'
  scope :untreated, :conditions => [ "diagnoses.treated = ?", false ]  
  scope :treated, :conditions => [ "diagnoses.treated = ?", true ]  
  
  def to_s
    str = disease.to_s
    str += ", #{body_part.to_s}" if body_part.present?
    str
  end
  
  def has_mirror?
    return false if !body_part.present? || siblings.empty? || body_part.mirror.blank?
    return siblings.select{ |diagnosis| self.body_part.mirror.id == diagnosis.body_part_id }.size > 0
  end
  
  def siblings
    return [] unless self.patient.present?
    self.patient.diagnoses.reject{ |diagnosis| diagnosis.id == self.id }
  end

end
