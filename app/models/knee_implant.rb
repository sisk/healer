class KneeImplant < Implant
  def self.patella_sizes
    { 0 => "Small", 1 => "Medium", 2 => "Large" }
  end
  def self.femur_diameters
    [60,65,70,75,80,85]
  end
  def self.tibia_diameters
    [60,65,70,75,80]
  end
  def self.tibia_thicknesses
    [10,12,14,16,20,22]
  end
  def self.tibia_types
    ["Metal-backed"]
  end
  def self.knee_types
    ["CR","PS","CC","Hinge"]
  end

  validates_numericality_of :femur_diameter, :allow_blank => true
  validates_numericality_of :tibia_diameter, :allow_blank => true
  validates_numericality_of :tibia_thickness, :allow_blank => true
  validates_numericality_of :patella_size, :allow_blank => true

  validates_inclusion_of :femur_diameter, :in => self.femur_diameters, :allow_blank => true
  validates_inclusion_of :tibia_type, :in => self.tibia_types, :allow_blank => true
  validates_inclusion_of :tibia_diameter, :in => self.tibia_diameters, :allow_blank => true
  validates_inclusion_of :tibia_thickness, :in => self.tibia_thicknesses, :allow_blank => true
  validates_inclusion_of :patella_size, :in => self.patella_sizes.keys, :allow_blank => true
  validates_inclusion_of :knee_type, :in => self.knee_types, :allow_blank => true

end
