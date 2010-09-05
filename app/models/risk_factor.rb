class RiskFactor < ActiveRecord::Base
  belongs_to :patient
  belongs_to :risk
  validates_presence_of :patient
  validates_presence_of :risk
  def to_s
    str = risk.to_s
    str << " (severe)" if severe?
    str
  end
end
