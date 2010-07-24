class Operation < ActiveRecord::Base
  def self.approaches
    ["Anterior","Lateral","Medial","Posterior","Dorsal","Lateral Transfibular"]
  end
  def self.difficulty_table
    { 0 => "Routine", 1 => "Moderate", 2 => "Severe" }
  end

  belongs_to :procedure
  belongs_to :patient
  belongs_to :diagnosis
  belongs_to :primary_surgeon, :class_name => "User", :foreign_key => "primary_surgeon_id"
  belongs_to :secondary_surgeon, :class_name => "User", :foreign_key => "secondary_surgeon_id"
  belongs_to :anesthesiologist, :class_name => "User", :foreign_key => "anesthesiologist_id"

  validates_presence_of :procedure
  validates_presence_of :patient
  validates_presence_of :date
  validates_numericality_of :difficulty
  validates_inclusion_of :difficulty, :in => self.difficulty_table.keys
  validates_inclusion_of :approach, :in => self.approaches
  
end
