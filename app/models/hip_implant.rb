class HipImplant < Implant
  def self.femur_diameters
    [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]
  end
  def self.femur_lengths
    [105,110,115,120,125,130,135,140,145,150,155,160,165,170,175,180,185,200,220,240]
  end
  def self.acetabulum_sizes
    [46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80]
  end
  def self.femur_head_sizes
    [22,26,28,30,32,36,40,44]
  end
  def self.neck_lengths
    [-6,-3,0,3,6,9,12]
  end

  validates_numericality_of :femur_diameter, :allow_blank => true
  validates_numericality_of :femur_length, :allow_blank => true
  validates_numericality_of :acetabulum_size, :allow_blank => true
  validates_numericality_of :femur_head_size, :allow_blank => true
  validates_numericality_of :neck_length, :allow_blank => true

  validates_inclusion_of :femur_diameter, :in => self.femur_diameters, :allow_blank => true
  validates_inclusion_of :femur_length, :in => self.femur_lengths, :allow_blank => true
  validates_inclusion_of :acetabulum_size, :in => self.acetabulum_sizes, :allow_blank => true
  validates_inclusion_of :femur_head_size, :in => self.femur_head_sizes, :allow_blank => true
  validates_inclusion_of :neck_length, :in => self.neck_lengths, :allow_blank => true

end
