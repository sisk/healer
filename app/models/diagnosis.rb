class Diagnosis < ActiveRecord::Base
  def self.severity_table
    { 0 => "Unremarkable", 1 => "Mild", 2 => "Moderate", 3 => "Severe" }
  end
  belongs_to :patient_case
  belongs_to :disease
  belongs_to :body_part
  has_many :operations # might just be has_one. TBD.
  has_many :xrays, :dependent => :destroy
  accepts_nested_attributes_for :xrays, :allow_destroy => true, :reject_if => proc { |attributes| attributes['photo'].blank? }

  validates_presence_of :patient_case
  validates_presence_of :disease
  validates_numericality_of :severity
  validates_inclusion_of :severity, :in => self.severity_table.keys

  default_scope :order => 'diagnoses.assessed_date DESC'

  # searchlogic would nullify these
  scope :untreated, where("diagnoses.treated = ?", false)
  scope :treated, where("diagnoses.treated = ?", true)

  def to_s
    str = disease.to_s
    str += ", #{body_part.to_s}" if body_part.present?
    str
  end

  def as_json(options={})
    # serializable_hash(options.merge({ :only => ["id", "trip_id", "status"], :joins => [:patient] }))
    {
      :id => id,
      :to_s => to_s,
      :severity => severity
    }
  end

  def has_mirror?
    return false if !body_part.present? || siblings.empty? || !body_part.has_mirror?
    return siblings.select{ |diagnosis| body_part.mirror.id == diagnosis.body_part_id }.size > 0
  end

  def siblings
    # FIXME buggy?
    return [] unless patient_case.present?
    patient_case.patient.diagnoses.reject{ |diagnosis| diagnosis.try(:id) == id }
  end

end
