class FollowUp < PatientInteraction
  has_and_belongs_to_many :symptoms
end
