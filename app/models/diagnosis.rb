class Diagnosis < ActiveRecord::Base
  def self.severity_table
    { 0 => "Unremarkable", 1 => "Mild", 2 => "Moderate", 3 => "Severe" }
  end
  belongs_to :patient_case
  belongs_to :disease
  belongs_to :body_part
  has_one :operation
  has_many :xrays, :dependent => :destroy
  accepts_nested_attributes_for :xrays, :allow_destroy => true, :reject_if => proc { |attributes| attributes['photo'].blank? }

  validates_presence_of :patient_case, :unless => lambda { |d| d.new_record? }
  validates_presence_of :body_part
  validates_numericality_of :severity
  validates_inclusion_of :severity, :in => self.severity_table.keys

  default_scope :order => 'diagnoses.assessed_date DESC'

  # searchlogic would nullify these
  scope :untreated, where("diagnoses.treated = ?", false)
  scope :treated, where("diagnoses.treated = ?", true)

  delegate :patient, :to => :patient_case

  def to_s
    str = disease.to_s
    str += ", #{body_part.to_s}" if body_part.present?
    str
  end

  def as_json(options={})
    # serializable_hash(options.merge({ :only => ["id", "status"], :joins => [:patient] }))
    {
      :id => id,
      :to_s => to_s,
      :severity => severity
    }
  end

=begin
TODO [cruft] 2011-08-15 possible cruft alert! if no one chirps for a while, kill this.
%>
  def has_mirror?
    return false if !body_part.present? || siblings.empty? || !body_part.mirror.present?
    return siblings.select{ |diagnosis| body_part.mirror.id == diagnosis.body_part_id }.size > 0
  end

<%
=end

  def siblings
    return [] unless patient.present?
    patient.diagnoses - [self]
  end

end
