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
  def self.desired_attributes
    [:femur_diameter,:tibia_diameter,:tibia_thickness,:patella_size,:tibia_type,:knee_type]
  end

  validates_numericality_of :femur_diameter, :allow_blank => false
  validates_numericality_of :tibia_diameter, :allow_blank => false
  validates_numericality_of :tibia_thickness, :allow_blank => false
  validates_numericality_of :patella_size, :allow_blank => false

  validates_inclusion_of :femur_diameter, :in => self.femur_diameters, :allow_blank => false
  validates_inclusion_of :tibia_type, :in => self.tibia_types, :allow_blank => false
  validates_inclusion_of :tibia_diameter, :in => self.tibia_diameters, :allow_blank => false
  validates_inclusion_of :tibia_thickness, :in => self.tibia_thicknesses, :allow_blank => false
  validates_inclusion_of :patella_size, :in => self.patella_sizes.keys, :allow_blank => false
  validates_inclusion_of :knee_type, :in => self.knee_types, :allow_blank => false

  validates_presence_of :femur_diameter
  validates_presence_of :tibia_diameter
  validates_presence_of :tibia_thickness
  validates_presence_of :patella_size
  validates_presence_of :tibia_type
  validates_presence_of :knee_type

end
