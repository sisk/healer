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
  belongs_to :primary_surgeon, :class_name => "User", :foreign_key => "primary_surgeon_id"
  belongs_to :secondary_surgeon, :class_name => "User", :foreign_key => "secondary_surgeon_id"
  belongs_to :anesthesiologist, :class_name => "User", :foreign_key => "anesthesiologist_id"

  has_one :implant
  has_one :knee_implant
  has_one :hip_implant

  has_many :xrays, :dependent => :destroy
  accepts_nested_attributes_for :xrays, :allow_destroy => true, :reject_if => proc { |attributes| attributes['photo'].blank? }
  
  validates_presence_of :procedure
  validates_presence_of :patient
  validates_presence_of :date
  validates_presence_of :body_part
  validates_numericality_of :difficulty
  validates_inclusion_of :difficulty, :in => self.difficulty_table.keys
  validates_inclusion_of :approach, :in => self.approaches, :allow_nil => true, :allow_blank => true
  validates_inclusion_of :ambulatory_order, :in => self.ambulatory_orders, :allow_nil => true, :allow_blank => true

  accepts_nested_attributes_for :knee_implant
  accepts_nested_attributes_for :hip_implant
  accepts_nested_attributes_for :patient

  default_scope :order => 'operations.schedule_order'

  def to_s
    "#{procedure.to_s} - #{date}"
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

  def self.order(ids)
    update_all(
      ['schedule_order = FIND_IN_SET(id, ?)', ids.join(',')],
      { :id => ids }
    )
  end
end
