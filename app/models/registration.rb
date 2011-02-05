class Registration < ActiveRecord::Base

  # time_in_words needs this
  include ActionView::Helpers::DateHelper

  def self.possible_statuses
    ["Pre-Screen","Registered","Checked In","Scheduled","Unscheduled","Preparation","Procedure","Recovery","Discharge","Checked Out"]
  end
  def self.complexity_units
    [1,2,3,4,5,6,7,8,9,10]
  end

  @registration_join = 'left outer join `trips` ON `trips`.`id` = `registrations`.`trip_id` left outer join `diagnoses` ON `diagnoses`.`registration_id` = `registrations`.`id` left outer join `patients` ON `patients`.`id` = `registrations`.`patient_id` left outer join `risk_factors` ON `risk_factors`.`patient_id` = `patients`.`id`'

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

  delegate :complexity_minutes, :to => :trip

  # scope :authorized, where("registrations.approved_at is not ?", nil).joins(:trip, :diagnoses, :patient => [:risk_factors])
  # scope :unauthorized, where("registrations.approved_at is ?", nil).joins(:trip, :patient => [:diagnoses, :risk_factors])
  scope :authorized, includes([:patient, :trip]).where("registrations.approved_at is not ?", nil)
  scope :unauthorized, includes([:patient, :trip]).where("registrations.approved_at is ?", nil)
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
  scope :unscheduled, where("registrations.room_id is ? or registrations.scheduled_day = ?", nil, 0)
  scope :scheduled, where("registrations.room_id is not ? and registrations.scheduled_day != ?", nil, 0)

  scope :room, lambda { |room_id| where("registrations.room_id = ?",room_id) if room_id.present? }
  scope :day, lambda { |num| where("registrations.scheduled_day = ?",num) if num.present? }
  scope :no_day, where("registrations.scheduled_day = ?",0)

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
      :body_parts => self.body_part_list,
      :time_in_words => self.time_in_words,
      :revision => self.revision?,
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

  # This only works for MySQL...and ergo not Heroku
  def self.order(ids)
    return if ids.blank?
    update_all(
      ['schedule_order = FIND_IN_SET(id, ?)', ids.join(',')],
      { :id => ids }
    )
  end

  def bilateral_diagnosis?
    return false if diagnoses.empty?
    return diagnoses.any?{ |diagnosis| diagnosis.has_mirror? }
  end


  def body_part_list
    if likely_bilateral?
      body_parts = diagnoses.map(&:body_part).compact
      body_part_names = body_parts.map(&:name_en)
      # part_counts = body_parts.map(&:name).inject(Hash.new(0)) {|h,x| h[x]+=1;h}
      p = []
      body_parts.each do |body_part|
        if body_part_names.count(body_part.name_en) > 1
          p << body_part.display_name + " (Bilateral)"
        else
          p << body_part.to_s
        end
      end
      return p.uniq.join(", ")
    else
      diagnoses.map(&:body_part).map(&:to_s).join(", ")
    end
  end

  def time_in_words
    # TODO - see if using partials instead of JSON objects improves performance and kludges like this one
    return "Time Unknown" if complexity.blank?
    str = distance_of_time_in_words(Time.now, Time.now + (complexity_minutes * complexity.to_i).to_i.minutes, false, { :two_words_connector => ", " })
    return str.blank? ? "Time Unknown" : str
  end

  def revision?
    return true if diagnoses.any?{ |d| d.revision }
    return patient.diagnoses.untreated.any?{ |d| d.revision }
  end

private

  def set_pre_screen
    status = "Pre-Screen"
  end

  def set_bilateral
    self.likely_bilateral = self.bilateral_diagnosis?
    true
  end

  def add_untreated_diagnoses
    self.diagnoses = patient.diagnoses.untreated
  end

  def clear_diagnoses
    Diagnosis.update_all("registration_id = NULL", :registration_id => self.id)
  end

end
