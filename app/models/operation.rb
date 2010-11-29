class Operation < ActiveRecord::Base
  def self.approaches
    ["Anterior","Lateral","Medial","Posterior","Dorsal","Lateral Transfibular"]
  end
  def self.difficulty_table
    { 0 => "Routine", 1 => "Moderate", 2 => "Severe" }
  end
  def self.ambulatory_orders
    ["Weight Bearing as Tolerated","Non-Weight Bearing","Partial Weight Bearing"]
  end

  belongs_to :procedure
  belongs_to :patient
  belongs_to :diagnosis
  belongs_to :body_part
  belongs_to :room
  belongs_to :registration
  belongs_to :trip
  belongs_to :primary_surgeon, :class_name => "User", :foreign_key => "primary_surgeon_id"
  belongs_to :secondary_surgeon, :class_name => "User", :foreign_key => "secondary_surgeon_id"
  belongs_to :anesthesiologist, :class_name => "User", :foreign_key => "anesthesiologist_id"

  has_one :implant
  has_one :knee_implant
  has_one :hip_implant

  has_many :xrays, :dependent => :destroy
  accepts_nested_attributes_for :xrays, :allow_destroy => true, :reject_if => proc { |attributes| attributes['photo'].blank? }
  
  validates_presence_of :patient
  # validates_presence_of :date
  # validates_presence_of :body_part
  validates_presence_of :registration
  validates_numericality_of :difficulty
  validates_inclusion_of :difficulty, :in => self.difficulty_table.keys
  validates_inclusion_of :approach, :in => self.approaches, :allow_nil => true, :allow_blank => true
  validates_inclusion_of :ambulatory_order, :in => self.ambulatory_orders, :allow_nil => true, :allow_blank => true
  
  before_validation :set_trip_id, :set_patient_id

  accepts_nested_attributes_for :knee_implant
  accepts_nested_attributes_for :hip_implant
  accepts_nested_attributes_for :patient

  scope :trip_id, lambda { |trip_id|
    { :include => :registration, :conditions => ["registrations.trip_id = ?",trip_id ] } if trip_id.present?
  }
  scope :room_id, lambda { |room_id|
    { :conditions => ["operations.room_id = ?",room_id ] } if room_id.present?
  }

  delegate :location, :location=, :to => :registration  

  def to_s
    [self.trip.try(:to_s), self.patient.try(:to_s), self.procedure.try(:to_s)].compact.join(" - ")
  end
  
  def as_json(options={})
    { :id => self.id, :registration_id => registration_id, :to_s => self.to_s, :photo => self.patient.displayed_photo(:tiny), :patient => self.patient.to_s, :location => self.location }
  end
  
  def build_implant(*args)
    # override method to deal with STI
    return implant if implant.present?
    case body_part.try(:name).try(:downcase)
    when "knee"
      self.implant = KneeImplant.new(:operation => self, :body_part => self.body_part)
    when "hip"
      self.implant = HipImplant.new(:operation => self, :body_part => self.body_part)
    else
      self.implant = Implant.new(:operation => self, :body_part => self.body_part)
    end
  end

  def self.order_schedule(registration_ids,trip_id,room_id)
    logger.debug("\n\n\nORDER\n\n\n")
    
    # update_all(
    #   ['schedule_order = FIND_IN_SET(id, ?)', registration_ids.join(',')],
    #   { :id => registration_ids }
    # )
  end
  
  private
  
  def set_trip_id
    self.trip_id = self.registration.try(:trip_id) if (self.trip_id.nil? || self.registration.try(:trip_id) != self.trip_id)
  end
  def set_patient_id
    self.patient_id = self.registration.try(:patient_id) if (self.patient_id.nil? || self.registration.try(:patient_id) != self.patient_id)
  end
  
end
