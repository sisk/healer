class KneeImplant < Implant
  def self.patella_sizes
    { 0 => "Small", 1 => "Medium", 2 => "Large" }
  end
  validates_inclusion_of :tibia_type, :in => %w(Metal-backed), :allow_nil => true
  validates_numericality_of :femur_diameter, :allow_nil => true
  validates_numericality_of :tibia_diameter, :allow_nil => true
  validates_numericality_of :knee_thickness, :allow_nil => true
  validates_numericality_of :patella_size, :allow_nil => true

  validates_inclusion_of :femur_diameter, :in => [60,65,70,75,80,85], :allow_nil => true
  validates_inclusion_of :tibia_type, :in => ["Metal-backed"], :allow_nil => true
  validates_inclusion_of :tibia_diameter, :in => [60,65,70,75,80], :allow_nil => true
  validates_inclusion_of :knee_thickness, :in => [10,12,14,16,20,22], :allow_nil => true
  validates_inclusion_of :patella_size, :in => KneeImplant::patella_sizes.keys, :allow_nil => true
  validates_inclusion_of :knee_type, :in => ["CR","PS","CC","Hinge"], :allow_nil => true

end
