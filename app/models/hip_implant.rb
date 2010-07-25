class HipImplant < Implant

  validates_numericality_of :femur_diameter, :allow_nil => true
  validates_numericality_of :femur_length, :allow_nil => true
  validates_numericality_of :acetabulum_size, :allow_nil => true
  validates_numericality_of :femur_head_size, :allow_nil => true
  validates_numericality_of :neck_length, :allow_nil => true

  validates_inclusion_of :femur_diameter, :in => [6,7,8,9,10,11,12,13,14,15,16,17,18,19,20], :allow_nil => true
  validates_inclusion_of :femur_length, :in => [200,220,240], :allow_nil => true
  validates_inclusion_of :acetabulum_size, :in => [46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80], :allow_nil => true
  validates_inclusion_of :femur_head_size, :in => [22,26,28,30,32,36,40,44], :allow_nil => true
  validates_inclusion_of :neck_length, :in => [-6,-3,0,3,6,9,12], :allow_nil => true

end
