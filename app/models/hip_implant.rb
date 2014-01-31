require "config"

class HipImplant < Implant
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

  validates_inclusion_of :femur_diameter, :in => Healer::Config.anatomy[:femur_diameters_hip], :allow_blank => false, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }
  validates_inclusion_of :femur_length, :in => Healer::Config.anatomy[:femur_lengths], :allow_blank => false, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }
  validates_inclusion_of :acetabulum_size, :in => Healer::Config.anatomy[:acetabulum_sizes], :allow_blank => false
  validates_inclusion_of :femur_head_size, :in => Healer::Config.anatomy[:femur_head_sizes], :allow_blank => false, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }
  validates_inclusion_of :neck_length, :in => Healer::Config.anatomy[:neck_lengths], :allow_blank => false, :unless => lambda { |i| HipImplant.procedures_not_requiring_femur.include?(i.procedure) }

  def self.procedures_not_requiring_femur
    @procedures_not_requiring_femur ||= Procedure.find_all_by_name_en("Revision - acetabulum only")
  end

  def procedures_not_requiring_acetabulum
    @procedures_not_requiring_acetabulum ||= Procedure.find_all_by_name_en("Revision - femur only")
  end

end
