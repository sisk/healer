class Operation < ActiveRecord::Base
  def self.approaches
    ["Anterior","Lateral","Medial","Posterior","Dorsal","Planter","Lateral Transfibular"]
  end
  def self.difficulty_table
    { 0 => "Routine", 1 => "Moderate", 2 => "Severe" }
  end
  def self.ambulatory_orders
    ["Weight Bearing as Tolerated","Non-Weight Bearing","Partial Weight Bearing"]
  end
  def self.anesthsia_types
    ["spinal","general"]
  end
  def self.peripheral_nerve_block_types
    ["femoral", "sciatic", "popliteal", "ankle", "none"]
  end

  default_scope order(:date)

  belongs_to :procedure
  belongs_to :patient
  belongs_to :diagnosis
  belongs_to :body_part
  belongs_to :room
  belongs_to :patient_case
  belongs_to :trip
  belongs_to :primary_surgeon, :class_name => "User", :foreign_key => "primary_surgeon_id"
  belongs_to :secondary_surgeon, :class_name => "User", :foreign_key => "secondary_surgeon_id"
  belongs_to :anesthesiologist, :class_name => "User", :foreign_key => "anesthesiologist_id"

  has_one :implant, :dependent => :destroy
  has_one :knee_implant, :dependent => :destroy
  has_one :hip_implant, :dependent => :destroy

  has_many :xrays, :dependent => :destroy
  accepts_nested_attributes_for :xrays, :allow_destroy => true, :reject_if => proc { |attributes| attributes['photo'].blank? }
  
  validates_presence_of :patient
  # validates_presence_of :date
  # validates_presence_of :body_part
  # validates_presence_of :patient_case
  validates_presence_of :diagnosis
  validates_numericality_of :difficulty
  validates_inclusion_of :difficulty, :in => self.difficulty_table.keys
  validates_inclusion_of :approach, :in => self.approaches, :allow_nil => true, :allow_blank => true
  validates_inclusion_of :ambulatory_order, :in => self.ambulatory_orders, :allow_nil => true, :allow_blank => true
  
  before_validation :set_trip_id, :set_patient_id

  accepts_nested_attributes_for :knee_implant
  accepts_nested_attributes_for :hip_implant
  accepts_nested_attributes_for :patient


  scope :trip, lambda { |trip_id|
    { :include => :patient_case, :conditions => ["patient_cases.trip_id = ?",trip_id ] } if trip_id.present?
  }
  scope :incomplete, where("operations.end is ?", nil)
  scope :complete, where("operations.end is not ?", nil)

  delegate :location, :location=, :to => :patient_case

  def to_s
    if procedure.present?
      str = procedure.to_s
      str += " (#{body_part.side})" if body_part.try(:side).present?
      return str
    else
      return body_part.present? ? body_part.to_s : "[Unspecified operation]"
    end
  end
  
  def as_json(options={})
    { :id => self.id, :patient_case_id => patient_case_id, :to_s => self.to_s, :photo => self.patient.displayed_photo(:tiny), :patient => self.patient.to_s, :location => self.location }
  end
  
  # def build_implant(*args)
  #   # override method to deal with STI
  #   return implant if implant.present?
  #   case body_part.try(:name_en).try(:downcase)
  #   when "knee"
  #     self.implant = KneeImplant.new(:operation => self, :body_part => self.body_part)
  #   when "hip"
  #     self.implant = HipImplant.new(:operation => self, :body_part => self.body_part)
  #   else
  #     self.implant = Implant.new(:operation => self, :body_part => self.body_part)
  #   end
  # end
  def display_xray
    return nil if xrays.empty?
    return xrays.first if xrays.size == 1 || xrays.all?{ |x| !x.primary? }
    return xrays.select{ |x| x.primary == true }.first
  end
  
  private
  
  def set_trip_id
    self.trip_id = self.patient_case.try(:trip_id) if (self.trip_id.nil? || self.patient_case.try(:trip_id) != self.trip_id)
  end
  def set_patient_id
    self.patient_id = self.patient_case.try(:patient_id) if (self.patient_id.nil? || self.patient_case.try(:patient_id) != self.patient_id)
  end
  
end
