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

  validates_presence_of :patient
  validates_presence_of :trip
  validates_inclusion_of :status, :in => self.possible_statuses, :allow_nil => true

  accepts_nested_attributes_for :patient
  
  default_scope :include => :patient, :order => 'patients.name_last, patients.name_first'
  
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
  scope :unscheduled, :conditions => [ "registrations.status in (?)", ["Registered","Unscheduled"] ]

  def to_s
    "#{patient.to_s} - #{trip.to_s}"
  end

  def as_json(options={})
    { :id => self.id, :to_s => self.to_s, :status => self.status, :photo => self.patient.displayed_photo(:tiny), :patient => self.patient.to_s, :location => self.location }
  end

  def authorize!(approved_by_id = nil)
    self.update_attributes(:approved_by_id => approved_by_id, :approved_at => Time.now, :status => "Registered")
  end
  def deauthorize!
    self.update_attributes(:approved_by_id => nil, :approved_at => nil, :status => "Pre-Screen")
  end

  def authorized?
    !approved_at.blank?
  end
  
  def in_facility?
    ["Checked In","Preparation","Procedure","Recovery","Discharge"].include?(status)
  end
  
  def schedule!
    self.status = "Scheduled" if ["Registered","Unscheduled"].include?(self.status)
    self.save if self.changed?
  end

  def unschedule!
    self.status = "Unscheduled"
    self.operations.destroy_all
    self.save if self.changed?
  end

private

  def set_pre_screen
    status = "Pre-Screen"
  end
  
end
