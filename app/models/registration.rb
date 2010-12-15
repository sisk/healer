class Registration < ActiveRecord::Base
  def self.possible_statuses
    ["Pre-Screen","Registered","Checked In","Scheduled","Unscheduled","Preparation","Procedure","Recovery","Discharge","Checked Out"]
  end

  before_create :set_pre_screen

  belongs_to :patient
  belongs_to :trip
  belongs_to :approved_by, :class_name => "User", :foreign_key => "approved_by_id"
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  has_many :operations
  has_many :diagnoses

  validates_presence_of :patient
  validates_presence_of :trip
  validates_inclusion_of :status, :in => self.possible_statuses, :allow_nil => true

  accepts_nested_attributes_for :patient
  
  default_scope :order => 'registrations.schedule_order'
  
  scope :authorized, :conditions => [ "registrations.approved_at is not ?", nil ]
  scope :unauthorized, :conditions => [ "registrations.approved_at is ?", nil ]  
  scope :search, Proc.new { |term|
    query = term.strip.gsub(',', '')
    logger.debug(query.inspect)
    first_last = query.split(" ")
    if query.present?
      if first_last.size == 2
        { :include => [:patient], :conditions => ["patients.name_first like ? and patients.name_last like ?","%#{first_last[0]}%","%#{first_last[1]}%" ] }
      else
        query = query.gsub(/[^\w@\.]/x,'')
        { :include => [:patient], :conditions => ["patients.name_last like ? or patients.name_first like ?","%#{query}%","%#{query}%" ] }
      end
    end
  }
  scope :unscheduled, :conditions => [ "registrations.room_id is ?", nil ]

  scope :room_id, lambda { |room_id|
    { :conditions => ["registrations.room_id = ?",room_id ] } if room_id.present?
  }

  before_save :set_bilateral

  def to_s
    # TODO there's a performance thing here where we query patients and trips table separately. improve it!
    "#{patient.to_s} - #{trip.to_s}"
  end

  def as_json(options={})
    # serializable_hash(options.merge({ :only => ["id", "trip_id", "status"], :joins => [:patient] }))
    {
      :id => self.id,
      :to_s => self.to_s,
      :status => self.status,
      :photo => self.patient.displayed_photo(:tiny),
      :patient => self.patient.to_s,
      :location => self.location,
      :body_parts => self.diagnoses.map(&:body_part).map(&:to_s).join(", "),
      :class => (self.likely_bilateral? ? "bilateral" : "")
    }
  end

  def authorize!(approved_by_id = nil)
    self.update_attributes(:approved_by_id => approved_by_id, :approved_at => Time.now, :status => "Registered")
    add_untreated_diagnoses
    true
  end
  def deauthorize!
    self.update_attributes(:approved_by_id => nil, :approved_at => nil, :status => "Pre-Screen")
    clear_diagnoses
    true
  end

  def authorized?
    !approved_at.blank?
  end
  
  def in_facility?
    ["Checked In","Preparation","Procedure","Recovery","Discharge"].include?(status)
  end
  
  def schedule
    self.status = "Scheduled" if ["Registered","Unscheduled"].include?(self.status)
  end

  def unschedule
    self.status = "Unscheduled"
  end

  def self.order(ids)
    update_all(
      ['schedule_order = FIND_IN_SET(id, ?)', ids.join(',')],
      { :id => ids }
    )
  end

  def bilateral_diagnosis?
    return false if diagnoses.empty?
    return diagnoses.any?{ |diagnosis| diagnosis.has_mirror? }
  end

private

  def set_pre_screen
    status = "Pre-Screen"
  end
  
  def set_bilateral
    self.likely_bilateral = self.bilateral_diagnosis?
  end
  
  def add_untreated_diagnoses
    self.diagnoses = patient.diagnoses.untreated
  end

  def clear_diagnoses
    self.diagnoses.clear
  end
  
end
