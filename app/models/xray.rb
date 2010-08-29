class Xray < ActiveRecord::Base
  
  belongs_to :diagnosis
  belongs_to :operation

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
    :path => ENV['S3_BUCKET'] ? "xrays/:attachment/:id/:style/:basename.:extension" : ":rails_root/public/system/xrays/:attachment/:id/:style/:basename.:extension",
    :url => ENV['S3_BUCKET'] ? "xrays/:attachment/:id/:style/:basename.:extension" : "/system/xrays/:attachment/:id/:style/:basename.:extension"

    validates_attachment_presence :photo

  def patient
    diagnosis.try(:patient) || operation.try(:patient)
  end

  def to_s
    str = "X-ray: #{patient.to_s}"
    str << " - " + date_time.to_s if date_time.present?
    return str
  end
  
end
