class Diagnosis < ActiveRecord::Base
  def self.severity_table
    { 0 => "Unremarkable", 1 => "Mild", 2 => "Moderate", 3 => "Severe" }
  end
  belongs_to :patient
  belongs_to :disease
  belongs_to :body_part
  has_many :operations
  has_many :xrays
  
  validates_presence_of :patient
  validates_presence_of :disease
  validates_numericality_of :severity
  validates_inclusion_of :severity, :in => self.severity_table.keys
  
  def to_s
    str = disease.to_s
    str << ", #{body_part.to_s}" if body_part.present?
    str
  end
end
