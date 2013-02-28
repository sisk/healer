class AdverseEvent < ActiveRecord::Base

  belongs_to :patient
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
      "Non-Union and Loose",
      "Other"
    ]
  end

  def to_s
    "Event logged #{created_at}"
  end

end