class PatientCase < ActiveRecord::Base

  # time_in_words needs this
  include ActionView::Helpers::DateHelper

  def self.possible_statuses
    ["Pre-Screen","Registered","Checked In","Scheduled","Unscheduled","Preparation","Procedure","Recovery","Discharge","Checked Out"]
  end
  def self.complexity_units
    [1,2,3,4,5,6,7,8,9,10]
  end

  @patient_case_join = 'left outer join `trips` ON `trips`.`id` = `patient_cases`.`trip_id` left outer join `diagnoses` ON `diagnoses`.`patient_case_id` = `patient_cases`.`id` left outer join `patients` ON `patients`.`id` = `patient_cases`.`patient_id` left outer join `risk_factors` ON `risk_factors`.`patient_id` = `patients`.`id`'

  before_create :set_pre_screen
  after_save :sync_bilateral, :set_case_group
  after_create :send_email_alert

  belongs_to :patient
  belongs_to :case_group
  belongs_to :trip
  belongs_to :approved_by, :class_name => "User", :foreign_key => "approved_by_id"
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  has_one :operation, :dependent => :destroy
  has_one :diagnosis, :dependent => :destroy
  has_many :xrays, :dependent => :destroy
  has_many :physical_therapies, :dependent => :destroy
  has_one :bilateral_case, :class_name => "PatientCase", :foreign_key => "bilateral_case_id"

  validates_presence_of :patient
  validates_presence_of :trip
  validates_inclusion_of :status, :in => self.possible_statuses, :allow_nil => true

  accepts_nested_attributes_for :patient
  accepts_nested_attributes_for :diagnosis
  accepts_nested_attributes_for :xrays

  default_scope :order => 'patient_cases.schedule_order'

  delegate :complexity_minutes, :to => :trip
  delegate :name, :to => :patient
  delegate :body_part, :to => :diagnosis, :allow_nil => true
  delegate :severity, :to => :diagnosis, :allow_nil => true

  # scope :authorized, where("patient_cases.approved_at is not ?", nil).joins(:trip, :diagnosis, :patient => [:risk_factors])
  # scope :unauthorized, where("patient_cases.approved_at is ?", nil).joins(:trip, :patient => [:diagnosis, :risk_factors])
  scope :authorized, includes([:patient, :trip]).where("patient_cases.approved_at is not ?", nil)
  scope :unauthorized, includes([:patient, :trip]).where("patient_cases.approved_at is ?", nil)

  scope :scheduled, where("patient_cases.case_group_id is not ?", nil)
  scope :unscheduled, where("patient_cases.case_group_id is ?", nil)

  scope :future, includes([:trip]).where("trips.start_date IS NULL OR (trips.start_date > ? AND (trips.end_date IS NULL OR trips.end_date > ?))", Time.zone.now, Time.zone.now)

  scope :search, Proc.new { |term|
    query = term.strip.gsub(',', '')
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
  scope :unscheduled, where("patient_cases.room_id is ? or patient_cases.scheduled_day = ?", nil, 0)
  scope :scheduled, where("patient_cases.room_id is not ? and patient_cases.scheduled_day != ?", nil, 0)

  # TODO should this be a model join?
  scope :room, lambda { |room_id| where("patient_cases.room_id = ?",room_id) if room_id.present? }
  scope :day, lambda { |num| where("patient_cases.scheduled_day = ?",num) if num.present? }
  scope :no_day, where("patient_cases.scheduled_day = ?",0)

  scope :male, :include => :patient, :conditions => ["patients.male = ?", true]
  scope :female, :include => :patient, :conditions => ["patients.male = ?", false]

  scope :bilateral, :conditions => ["patient_cases.bilateral_case_id is not ?", nil]

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
      :body_part => self.body_part,
      :time_in_words => self.time_in_words,
      :revision => self.revision?
    }
  end

  def authorize!(approved_by_id = nil)
    self.update_attributes(:approved_by_id => approved_by_id, :approved_at => Time.now, :status => "Registered")
    true
  end

  def deauthorize!
    self.update_attributes(:approved_by_id => nil, :approved_at => nil, :status => "Pre-Screen")
    true
  end

  def authorized?
    !approved_at.blank?
  end

  def treated?
    operation.present?
  end

  def in_facility?
    ["Checked In","Preparation","Procedure","Recovery","Discharge"].include?(status)
  end

  def schedule!
    self.status = "Scheduled" if ["Registered","Unscheduled"].include?(self.status)
    self.save
  end

  def unschedule!
    self.attributes = { :status => "Unscheduled", :room_id => nil, :scheduled_day => 0 }
    self.save
  end

  # This only works for MySQL...and ergo not Heroku
  def self.order(ids)
    return if ids.blank?
    update_all(
      ['schedule_order = FIND_IN_SET(id, ?)', ids.join(',')],
      { :id => ids }
    )
  end

  def time_in_words
    # TODO - see if using partials instead of JSON objects improves performance and kludges like this one
    return "Time Unknown" if complexity.blank?
    str = distance_of_time_in_words(Time.now, Time.now + (complexity_minutes * complexity.to_i).to_i.minutes, false, { :two_words_connector => ", " })
    return str.blank? ? "Time Unknown" : str
  end

  def revision?
    diagnosis.try(:revision) || false
  end

  def display_xray
    return nil if xrays.empty?
    return xrays.first if xrays.size == 1 || xrays.all?{ |x| !x.primary? }
    return xrays.select{ |x| x.primary == true }.first
  end

  def related_untreated_cases
    patient.patient_cases.select{ |c| c.operation.nil? } - [self]
  end

  def self.group_cases(patient_cases)
    raise "Invalid cases." unless patient_cases.is_a?(Array)
    raise "Only cases may be grouped." unless patient_cases.all?{ |pc| pc.is_a?(PatientCase) }
    raise "All grouped cases must be authorized." unless patient_cases.all?{ |pc| pc.authorized? }
    raise "All grouped cases must belong to the same trip." if patient_cases.map(&:trip_id).uniq.compact.size > 1

    # Try to find the first relevant case group from cases. We're bundling them together, so it doesn't really matter which is which.
    # If we don't have a valid ID, then no case groups existed. Make one.
    case_group_id = patient_cases.map(&:case_group_id).uniq.compact.first || CaseGroup.create(:trip_id => patient_cases.map(&:trip_id).uniq.first).try(:id)

    # Make single case group applicable to all cases
    patient_cases.each{ |pc| pc.update_attributes(:case_group_id => case_group_id) }
  end

private

  def set_case_group
    if self.authorized?
      self.update_attribute(:case_group_id, CaseGroup.create(:trip_id => self.trip_id).try(:id)) unless self.case_group.present?
    else
      self.case_group.remove(self) if self.case_group.present?
    end
  end

  def sync_bilateral
    bilateral_case.update_attribute(:bilateral_case_id, self.id) if bilateral_case.present? && bilateral_case.bilateral_case_id != self.id
  end

  def set_pre_screen
    status = "Pre-Screen"
  end

  def send_email_alert
    if created_by.present? && created_by.has_role?("liaison")
      emails = trip.alert_users.map(&:email).compact.uniq
      Mailer.case_added(self,emails).deliver
    end
  end

end
