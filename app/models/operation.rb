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
  belongs_to :primary_surgeon, :class_name => "User", :foreign_key => "primary_surgeon_id"
  belongs_to :secondary_surgeon, :class_name => "User", :foreign_key => "secondary_surgeon_id"
  belongs_to :anesthesiologist, :class_name => "User", :foreign_key => "anesthesiologist_id"

  has_one :implant
  has_one :knee_implant
  has_one :hip_implant

  validates_presence_of :procedure
  validates_presence_of :patient
  validates_presence_of :date
  validates_numericality_of :difficulty
  validates_inclusion_of :difficulty, :in => self.difficulty_table.keys
  validates_inclusion_of :approach, :in => self.approaches, :allow_nil => true
  validates_inclusion_of :ambulatory_order, :in => self.ambulatory_orders, :allow_nil => true

  accepts_nested_attributes_for :knee_implant
  accepts_nested_attributes_for :hip_implant
  accepts_nested_attributes_for :patient


  def to_s
    "#{procedure.to_s} - #{date}"
  end
end
