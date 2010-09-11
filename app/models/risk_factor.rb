class RiskFactor < ActiveRecord::Base
  def self.severity_table
    { 0 => "Unremarkable", 1 => "Mild", 2 => "Moderate", 3 => "Severe" }
  end
  belongs_to :patient
  belongs_to :risk
  validates_presence_of :patient
  validates_presence_of :risk
  validates_numericality_of :severity
  validates_inclusion_of :severity, :in => self.severity_table.keys
  def to_s
    str = risk.to_s
    str += " (#{RiskFactor.severity_table[severity]})" if severity.present?
    str
  end
end
