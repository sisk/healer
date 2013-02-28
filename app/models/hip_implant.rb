class HipImplant < Implant
  def self.femur_diameters
    [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]
  end
  def self.femur_lengths
    [105,110,115,120,125,130,135,140,145,150,155,160,165,170,175,180,185,200,220,240]
  end
  def self.acetabulum_sizes
    [40,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80]
  end
  def self.femur_head_sizes
    [22,26,28,30,32,36,40,44]
  end
  def self.neck_lengths
    [-6,-3,0,3,6,9,12]
  end
  def self.prosthesis_types
    # TODO migration to fix biometric to bimetric
    ["bimetric","calcar","taperloc","ranawat socket"]
  end

  def self.surface_options
    ["Polyethylene","Ceramic","Metal"]
  end

  def self.desired_attributes
    [:femur_diameter, :femur_length, :acetabulum_size, :femur_head_size, :neck_length, :prosthesis_type]
  end

  delegate :procedure, :to => :operation

  validates_numericality_of :femur_diameter, :allow_blank => false, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }
  validates_numericality_of :femur_length, :allow_blank => false, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }
  validates_numericality_of :acetabulum_size, :allow_blank => false
  validates_numericality_of :femur_head_size, :allow_blank => false, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }
  validates_numericality_of :neck_length, :allow_blank => false, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }

  validates_presence_of :prosthesis_type
  validates_presence_of :femur_length, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.operation.procedure) }
  validates_presence_of :acetabulum_size
  validates_presence_of :femur_head_size, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }
  validates_presence_of :neck_length, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }
  validates_presence_of :femur_diameter, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }

  validates_inclusion_of :femur_diameter, :in => self.femur_diameters, :allow_blank => false, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }
  validates_inclusion_of :femur_length, :in => self.femur_lengths, :allow_blank => false, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }
  validates_inclusion_of :acetabulum_size, :in => self.acetabulum_sizes, :allow_blank => false
  validates_inclusion_of :femur_head_size, :in => self.femur_head_sizes, :allow_blank => false, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }
  validates_inclusion_of :neck_length, :in => self.neck_lengths, :allow_blank => false, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }

  def self.procedures_not_requiring_femur
    @procedures_not_requiring_femur ||= Procedure.find_all_by_name_en("Revision - acetabulum only")
  end

  def procedures_not_requiring_acetabulum
    @procedures_not_requiring_acetabulum ||= Procedure.find_all_by_name_en("Revision - femur only")
  end

end
