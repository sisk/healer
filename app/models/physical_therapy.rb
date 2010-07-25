class PhysicalTherapy < PatientInteraction
  validates_numericality_of :number_of_assistances, :allow_nil => true
  validates_inclusion_of :number_of_assistances, :in => 0..10, :allow_nil => true
end
