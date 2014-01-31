class KneeImplant < Implant
  def self.desired_attributes
    [:femur_diameter,:tibia_diameter,:tibia_thickness,:patella_size,:tibia_type,:knee_type]
  end

  validates_numericality_of :femur_diameter, :allow_blank => false
  validates_numericality_of :tibia_diameter, :allow_blank => false
  validates_numericality_of :tibia_thickness, :allow_blank => false
  validates_numericality_of :patella_size, :allow_blank => true

  validates_inclusion_of :femur_diameter, :in => Healer::Config.anatomy[:femur_diameters_knee], :allow_blank => false
  validates_inclusion_of :tibia_type, :in => Healer::Config.implants[:tibia_types], :allow_blank => false
  validates_inclusion_of :tibia_diameter, :in => Healer::Config.anatomy[:tibia_diameters], :allow_blank => false
  validates_inclusion_of :tibia_thickness, :in => Healer::Config.anatomy[:tibia_thicknesses], :allow_blank => false
  validates_inclusion_of :knee_type, :in => Healer::Config.implants[:knee_types], :allow_blank => false

  validates_presence_of :femur_diameter
  validates_presence_of :tibia_diameter
  validates_presence_of :tibia_thickness
  validates_presence_of :tibia_type
  validates_presence_of :knee_type
end
