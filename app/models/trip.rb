class Trip < ActiveRecord::Base
  # TODO js: deprecate friendly_id
  extend FriendlyId
  friendly_id :nickname

  belongs_to :facility
  validates_presence_of :country, :nickname, :start_date
  validates_uniqueness_of :nickname
  has_many :patient_cases
  has_many :appointments
  has_many :patients, :through => :patient_cases, :uniq => true
  has_many :authorized_patients, :through => :patient_cases, :source => :patient, :conditions => ["patient_cases.approved_at is not ?", nil], :uniq => true
  has_and_belongs_to_many :users, :uniq => true

  default_scope order('start_date desc')

  before_validation :set_nickname

  # TODO these scopes need to be revised to reflect practical realities
  scope :current, lambda {
    where("trips.start_date IS NOT NULL AND trips.start_date <= ? AND (trips.end_date IS NULL OR (trips.end_date IS NOT NULL AND trips.end_date > ?))", Time.zone.now, Time.zone.now)
  }
  scope :future, lambda {
    where("trips.start_date IS NULL OR (trips.start_date > ? AND (trips.end_date IS NULL OR trips.end_date > ?))", Time.zone.now, Time.zone.now)
  }
  scope :next, lambda {
    where("trips.start_date IS NOT NULL AND (trips.start_date > ? AND (trips.end_date IS NULL OR trips.end_date < ?))", Time.zone.now + 1.day, Time.zone.now + 10.months)
  }
  scope :past, lambda {
    where("trips.end_date IS NOT NULL AND trips.end_date <= ?", Time.zone.now)
  }
  scope :country, Proc.new { |query|
    {
      :conditions => ["trips.country = ?",query]
    } if query.present?
  }

  def daily_complexity_units
    return 0 if [complexity_minutes, daily_hours].any?{ |i| i.blank? }
    (60/complexity_minutes) * daily_hours
  end

  def status
    return "unknown" unless start_date.present?
    return "complete" if end_date.present? && (end_date < Date.today)
    if start_date >= Date.today
      if start_date <= Date.today + 2.months
        return "scheduling"
      end
      return "planning"
    else
      if procedure_start_date.present? && Date.today <= procedure_start_date + number_of_operation_days.days
        return "active"
      elsif procedure_start_date.present? && Date.today > procedure_start_date + number_of_operation_days.days
        return "cooldown"
      end
      return "preparing"
    end
  end

  def current_day
    if status == "active"
      return ((procedure_start_date.to_time-start_date.to_time)/(60*60*24) + 1).to_i
    end
  end

  def alert_users
    users.in_role(:admin)
  end

  private #####################################################################

  def set_nickname
    unless nickname.present?
      year = start_date.blank? ? "" : start_date.strftime("%Y")
      self.nickname = Carmen::Country.coded(country).name.downcase + year
    end
  end

end