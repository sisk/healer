class Xray < ActiveRecord::Base
  
  belongs_to :diagnosis # 2011-07-10 marked for death when case transition complete
  belongs_to :operation
  belongs_to :patient_case
  
  scope :pre_op, where('xrays.operation_id is ?', nil)
  scope :post_op, where('xrays.operation_id is not ?', nil)

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
    :path => ENV['S3_BUCKET'].present? ? "xrays/:attachment/:id/:style.:extension" : ":rails_root/public/system/xrays/:attachment/:id/:style.:extension",
    :url => ENV['S3_BUCKET'].present? ? "xrays/:attachment/:id/:style.:extension" : "/system/xrays/:attachment/:id/:style.:extension"

  validates_attachment_presence :photo

  def patient_case
    diagnosis.try(:patient_case) || operation.try(:patient_case)
  end

  def to_s
    str = "X-ray: #{patient_case.to_s}"
    str += " - " + date_time.to_s if date_time.present?
    return str
  end
  
end
