class AdverseEvent < ActiveRecord::Base

  belongs_to :patient
  belongs_to :patient_case, :foreign_key => :case_id
  validates_presence_of :patient
  belongs_to :entered_by, :class_name => "User", :foreign_key => "entered_by_id"

  def self.event_types
    [
      "Instability",
      "Phlebitis",
      "Pulmonary embolus",
      "Infection",
      "Dislocation",
      "Fracture",
      "Non-Union",
      "Loose",
      "Peripheral Nerve Palsy",
      "Other"
    ]
  end

  def to_s
    "#{event_type} - #{self.patient_case ? "on #{patient_case.body_part} - #{patient_case.operation} - #{date_of_occurrence}" : "" }"
  end

end
