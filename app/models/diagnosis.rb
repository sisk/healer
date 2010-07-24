class Diagnosis < ActiveRecord::Base
  belongs_to :patient
  belongs_to :disease
  belongs_to :body_part
  
  validates_presence_of :patient
  validates_presence_of :disease
  validates_numericality_of :severity
end
