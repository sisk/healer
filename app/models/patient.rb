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
  
  has_many :patient_interactions
  has_many :diagnoses
  has_many :operations

  default_scope :order => 'patients.name_last, patients.name_first'
  
  # Paperclip
  has_attached_file :photo,
    :styles => {
      :thumb=> "100x100#",
      :small  => "150x150>" },
    :storage => ENV['S3_BUCKET'] ? :s3 : :filesystem,
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :bucket => ENV['S3_BUCKET'],
    :path => ":attachment/:id"

  
  def to_s(*args)
    name(*args)
  end
  def name(*args)
    [*args].flatten.include?(:last_first) ? [name_last, name_first].join(", ") : [name_first, name_last].join(" ")
  end
  
end
