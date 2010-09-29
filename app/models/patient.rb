class Patient < ActiveRecord::Base
  validates_presence_of :name_first, :message => "can't be blank"
  validates_presence_of :name_last, :message => "can't be blank"
  validates_inclusion_of :male, :in => [true, false]

  validates :email, :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i},
                    :allow_blank => true,
                    :allow_nil => true
                    # :email => true
  
  has_many :patient_interactions, :dependent => :destroy
  has_many :diagnoses, :dependent => :destroy
  has_many :operations, :dependent => :destroy
  has_many :registrations, :dependent => :destroy
  has_many :risk_factors, :dependent => :destroy

  accepts_nested_attributes_for :risk_factors, :allow_destroy => true, :reject_if => proc { |attributes| attributes['risk_id'].blank? }

  default_scope :order => 'patients.name_last, patients.name_first'

  scope :no_registrations, :conditions => ["patients.id NOT IN (SELECT patient_id FROM registrations)"]
  scope :search, Proc.new { |term|
    query = term.strip.gsub(',', '')
    logger.debug(query.inspect)
    first_last = query.split(" ")
    if query.present?
      if first_last.size == 2
        { :conditions => ["patients.name_first like ? and patients.name_last like ?","%#{first_last[0]}%","%#{first_last[1]}%" ] }
      else
        query = query.gsub(/[^\w@\.]/x,'')
        { :conditions => ["patients.name_last like ? or patients.name_first like ?","%#{query}%","%#{query}%" ] }
      end
    end
  }

  named_scope :lookup, Proc.new { |term|
    query = term.strip.gsub(',', '').gsub(/[^\w@\.]/x,'').gsub(' ','|')
    {
      :conditions => ["people.name_last regexp ? or people.name_first regexp ? or people.employee_id regexp ? or people.email regexp ?",query,query,query,query],
      :order => 'people.name_last, people.name_first'
    } if query.present?
  }


  # Paperclip
  has_attached_file :photo,
    :styles => {
      :tiny=> "60x60#",
      :thumb=> "100x100#",
      :small  => "200x200>" },
    :storage => ENV['S3_BUCKET'] ? :s3 : :filesystem,
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :bucket => ENV['S3_BUCKET'],
    :path => ENV['S3_BUCKET'] ? "patients/:attachment/:id/:style/:basename.:extension" : ":rails_root/public/system/patients/:attachment/:id/:style/:basename.:extension",
    :url => ENV['S3_BUCKET'] ? "patients/:attachment/:id/:style/:basename.:extension" : "/system/patients/:attachment/:id/:style/:basename.:extension"
  
  def to_s(*args)
    name(*args)
  end
  def name(*args)
    [*args].flatten.include?(:last_first) ? [name_last, name_first].join(", ") : [name_first, name_last].join(" ")
  end
  def short_name
    name_first || name_middle || name_last
  end
  
  def one_line_address
    str = [address1, address2, city, state, zip, country].reject{ |a| a.blank? }.join(", ")
    return str.blank? ? nil : str
  end

  def registered?
    !registrations.empty?
  end

  def has_contact?
    return %w(address1 address2 city state zip country phone email).any?{ |field| self.send(field).present? }
  end

  def available_risks
    Risk.all - self.risk_factors.collect{ |rf| rf.risk }
  end
  
end
