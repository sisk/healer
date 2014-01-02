class Patient < ActiveRecord::Base

  PHOTO_DIR = (Rails.env == "development") ? "_development/patients/:attachment/:id/:style.:extension" : "patients/:attachment/:id/:style.:extension"

  attr_accessor :weight_unit, :height_unit
  before_save :set_weight, :set_height, :set_name_full

  validates_presence_of :name_full
  validates_inclusion_of :male, :in => [true, false]

  validates :email, :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i},
                    :allow_blank => true,
                    :allow_nil => true
                    # :email => true

  has_many :patient_interactions, :dependent => :destroy
  has_many :operations, :through => :patient_cases
  has_many :patient_cases, :dependent => :destroy
  has_many :risk_factors, :dependent => :destroy
  has_many :adverse_events, :dependent => :destroy
  has_many :risks, :through => :risk_factors
  has_many :case_groups, :through => :patient_cases, :uniq => true

  accepts_nested_attributes_for :risk_factors, :allow_destroy => true, :reject_if => proc { |attributes| attributes['risk_id'].blank? }

  # default_scope :order => 'patients.name_first, patients.name_last'

  scope :ordered_by_id, :order => 'patients.id'
  scope :ordered_by_name_first, :order => 'patients.name_first, patients.name_last'
  scope :ordered_by_name_last, :order => 'patients.name_last, patients.name_first'

  scope :no_patient_cases, :conditions => ["patients.id NOT IN (SELECT patient_id FROM patient_cases)"]

  scope :name_full_like, Proc.new { |query|
    if connection_config[:adapter] == "postgresql"
      { :conditions => ["patients.name_full ILIKE ?", "%#{query}%"] }
    else
      { :conditions => ["patients.name_full like ?", "%#{query}%"] }
    end
  }

  scope :country, Proc.new { |query|
    {
      :conditions => ["patients.country = ?",query]
    } if query.present?
  }

  scope :body_part_name, lambda { |name|
    if name.present?
      { :include => { :patient_cases => :body_part }, :conditions => ["lower(body_parts.name_en) in (?)",Array(name).map(&:downcase)] }
    end
  }
  scope :authorized, includes([:patient_cases]).where("patient_cases.approved_at is not ?", nil)
  scope :unauthorized, includes([:patient_cases]).where("patient_cases.approved_at is ?", nil)

  # Paperclip
  has_attached_file :photo,
    :styles => {
      :tiny=> "60x60#",
      :thumb=> "100x100#",
      :small  => "200x200>" },
    :storage => ENV['S3_BUCKET'].present? ? :s3 : :filesystem,
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :bucket => ENV['S3_BUCKET'],
    :path => ENV['S3_BUCKET'].present? ? PHOTO_DIR : ":rails_root/public/system/#{PHOTO_DIR}",
    :url => ENV['S3_BUCKET'].present? ? PHOTO_DIR : "/system/#{PHOTO_DIR}"

  def self.search(query)
    query_items = query.split(" ")

    current_scope = name_full_like(query_items.shift)

    query_items.each do |item|
      current_scope = current_scope.name_full_like(item)
    end

    current_scope
  end

  def to_s(*args)
    name(args.extract_options!)
  end

  # TODO js: make this a decorator concern
  def name(options = {})
    str = ""
    str << "#{id} - " if options[:with_id].present? && options[:with_id]
    str << [name_first.strip, name_middle.strip, name_last.strip].reject{ |e| e.empty? }.join(" ")
    return str
  end

  def short_name
    name_first || name_middle || name_last
  end

  def inline_address(join = ", ")
    str = [address1, address2, city, state, zip, country].reject{ |a| a.blank? }.join(join)
    return str.blank? ? nil : str
  end

  def registered?
    !patient_cases.empty?
  end

  def has_contact?
    return %w(address1 address2 city state zip country phone email).any?{ |field| self.send(field).present? }
  end

  def available_risks
    Risk.all - self.risks
  end

  def displayed_photo(size)
    return photo.url(size) if photo.exists?
    (self.male.nil? || self.male?) ? "male-generic.gif" : "female-generic.gif"
  end

  def has_medical_detail?
    return (risk_factors.present? || other_diseases.present? || medications.present? || allergies.present?)
  end

  def age
    if birth.present?
      day_diff = Time.now.day - birth.day
      month_diff = Time.now.month - birth.month - (day_diff < 0 ? 1 : 0)
      Time.now.year - birth.year - (month_diff < 0 ? 1 : 0)
    end
  end

  private ######################################################################

  def set_weight
    self.weight_kg = to_kg(self.weight_kg) if self.weight_unit == "pounds"
  end

  def set_height
    self.height_cm = to_cm(self.height_cm) if self.height_unit == "inches"
  end

  def set_name_full
    self.name_full = "#{self.name_first} #{self.name_middle} #{self.name_last}"
  end

  def to_kg(pounds)
    ((pounds / 2.20462262) * 100).round.to_f / 100
  end

  def to_cm(inches)
    ((inches / 0.393700787) * 100).round.to_f / 100
  end

end
