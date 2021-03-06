class Operation < ActiveRecord::Base

  default_scope order(:date)

  belongs_to :procedure
  belongs_to :room
  belongs_to :patient_case
  belongs_to :primary_surgeon, :class_name => "User", :foreign_key => "primary_surgeon_id"
  belongs_to :secondary_surgeon, :class_name => "User", :foreign_key => "secondary_surgeon_id"
  belongs_to :anesthesiologist, :class_name => "User", :foreign_key => "anesthesiologist_id"

  has_one :implant, :dependent => :destroy
  has_one :knee_implant, :dependent => :destroy
  has_one :hip_implant, :dependent => :destroy

  has_many :xrays, :dependent => :destroy
  accepts_nested_attributes_for :xrays, :allow_destroy => true, :reject_if => proc { |attributes| attributes['photo'].blank? }

  # validates_presence_of :date
  validates_presence_of :patient_case
  validates_numericality_of :difficulty
  validates_inclusion_of :difficulty, :in => Healer::Config.operation[:difficulty_table].keys.map{ |k| k.to_i }
  validates_inclusion_of :approach, :in => Healer::Config.operation[:approaches], :allow_nil => true, :allow_blank => true
  validates_inclusion_of :ambulatory_order, :in => Healer::Config.operation[:ambulatory_orders], :allow_nil => true, :allow_blank => true

  accepts_nested_attributes_for :knee_implant
  accepts_nested_attributes_for :hip_implant
  accepts_nested_attributes_for :patient_case

  scope :trip, lambda { |trip_id|
    { :include => :patient_case, :conditions => ["patient_cases.trip_id = ?",trip_id ] } if trip_id.present?
  }
  scope :incomplete, where("operations.end is ?", nil)
  scope :complete, where("operations.end is not ?", nil)

  delegate :location, :location=, :patient, :trip, :disease, :anatomy, :to => :patient_case, :allow_nil => true

  after_initialize do
    self.osteotomy ||= Healer::Config.operation[:osteotomy_options].first
    self.anesthesia_type ||= Healer::Config.operation[:anesthsia_types].first
    self.peripheral_nerve_block_type ||= Healer::Config.operation[:peripheral_nerve_block_types].first
    self.ambulatory_order ||= Healer::Config.operation[:ambulatory_orders].first
  end

  def to_s
    procedure.present? ? procedure.to_s : "[Unspecified procedure]"
  end

  def as_json(options={})
    { :id => self.id, :patient_case_id => patient_case_id, :to_s => self.to_s, :photo => self.patient.displayed_photo(:tiny), :patient => self.patient.to_s, :location => self.location }
  end

  def build_implant(*args)
    return implant if implant.present?
    case patient_case.anatomy
    when "knee"
      KneeImplant.new(:operation => self)
    when "hip"
      HipImplant.new(:operation => self)
    else
      Implant.new(:operation => self)
    end
  end

  def display_xray
    return nil if xrays.empty?
    return xrays.first if xrays.size == 1 || xrays.all?{ |x| !x.primary? }
    return xrays.select{ |x| x.primary == true }.first
  end

end
